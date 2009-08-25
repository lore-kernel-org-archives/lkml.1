Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZHYCl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZHYCl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 22:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZHYCl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 22:41:27 -0400
Received: from mail142.messagelabs.com ([216.82.249.99]:56034 "HELO
	mail142.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754100AbZHYCl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 22:41:26 -0400
X-VirusChecked: Checked
X-Env-Sender: Haneef.Syed@lntinfotech.com
X-Msg-Ref: server-13.tower-142.messagelabs.com!1251168087!60902245!1
X-StarScan-Version: 6.1.3; banners=lntinfotech.com,-,-
X-Originating-IP: [203.101.96.4]
To: kvm-owner@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: kvm-76 aborted on on ibm server
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
Message-ID: <OF47BB4970.A0E8286A-ON6525761D.000E7E00-6525761D.000EC701@lntinfotech.com>
From: Haneef Syed <Haneef.Syed@lntinfotech.com>
Date: Tue, 25 Aug 2009 08:11:25 +0530
X-MIMETrack: Serialize by Router on BANGALORE/LNTINFOTECH(Release 7.0.3|September 26, 2007) at
 08/25/2009 08:11:27 AM,
	Serialize complete at 08/25/2009 08:11:27 AM,
	Itemize by SMTP Server on BangaloreSMTP/LNTINFOTECH(Release 7.0.3|September
 26, 2007) at 08/25/2009 08:12:57 AM,
	Serialize by Router on BangaloreSMTP/LNTINFOTECH(Release 7.0.3|September 26, 2007) at
 08/25/2009 08:12:59 AM,
	Serialize complete at 08/25/2009 08:12:59 AM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using kvm-76 on 2.6.21mv kernel on ibm server x3650(64bit processor) 
target, I got the 

following error.Any suggestions..

unhandled vm exit: 0x80000021 vcpu_id 0
rax 000000000000b101 rbx 0000000000000000 rcx 0000000000000000 rdx 
0000000000000000
rsi 0000000000000000 rdi 0000000000000000 rsp 0000000000000ff8 rbp 
0000000000000000
r8  0000000000000000 r9  0000000000000000 r10 0000000000000000 r11 
0000000000000000
r12 0000000000000000 r13 0000000000000000 r14 0000000000000000 r15 
0000000000000000
rip 000000000000fe6e rflags 00023002
cs 0100 (00000000/ffffffff p 1 dpl 0 db 1 s 1 type b l 0 g 1 avl 0)
ds 0108 (00000000/ffffffff p 1 dpl 0 db 1 s 1 type 3 l 0 g 1 avl 0)
es 0000 (00000000/00000000 p 0 dpl 0 db 0 s 0 type 0 l 0 g 0 avl 0)
ss 0108 (00000000/ffffffff p 1 dpl 0 db 1 s 1 type 3 l 0 g 1 avl 0)
fs 0000 (00000000/ffffffff p 0 dpl 0 db 0 s 0 type 0 l 0 g 0 avl 0)
gs 0000 (00000000/ffffffff p 0 dpl 0 db 0 s 0 type 0 l 0 g 0 avl 0)
tr 0148 (ffffffffc04405c0/00002067 p 1 dpl 0 db 0 s 0 type b l 0 g 0 avl 
0)
ldt 0000 (00000000/00000000 p 0 dpl 0 db 0 s 0 type 0 l 0 g 0 avl 0)
gdt ffff5020/2cf
idt ffff52f0/7ff
cr0 8001003b cr2 0 cr3 1005000 cr4 2d4 cr8 0 efer 0
Aborted


______________________________________________________________________
