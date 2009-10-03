Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbZJCGvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbZJCGvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 02:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbZJCGvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 02:51:05 -0400
Received: from bay0-omc3-s4.bay0.hotmail.com ([65.54.246.204]:59199 "EHLO
	bay0-omc3-s4.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007AbZJCGvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 02:51:05 -0400
Message-ID: <BAY105-W49B4F8CFD160524E8855A6C3D10@phx.gbl>
X-Originating-IP: [173.64.154.25]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <andi@firstfloor.org>
CC: <macro@linux-mips.org>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>
Subject: RE: I/O APIC: Timer through 8259A revamp
Date: Fri, 2 Oct 2009 23:51:08 -0700
Importance: Normal
In-Reply-To: <20090423180419.GT13896@one.firstfloor.org>
References: <fa.LVGNb1leZ16O2EUrcLYbCwtL9mc@ifi.uio.no>
 <fa.DPrbiibT7M43HJi+nTdM88e1eOQ@ifi.uio.no>
 <fa.p4mWFgWCFwhnKR83MseIShfc6uQ@ifi.uio.no>
 <fb0aeafb-a24b-413f-8d74-19c28de7faff@u9g2000pre.googlegroups.com>
X-OriginalArrivalTime: 03 Oct 2009 06:51:08.0375 (UTC) FILETIME=[E2BFCE70:01CA43F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 <20090423180419.GT13896@one.firstfloor.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0



> On Thu=2C Apr 23=2C 2009 at 10:45:03AM -0700=2C yuhong wrote:
>>>  The new burst of breakage came with the invention of ACPI and its tabl=
es
>>> for interrupt routing for the APIC.
>> Yep=2C when NVIDIA and ATI entered the chipset market=2C who would have
>> predicted that it would cause more 8254 and APIC related troubles? Or
>> it would be years before it were finally fixed properly? Even worse=2C
>> ATI made chipsets before AMD and Intel introduced their 64-bit CPUs=2C
>> yet it was the x86-64 architecture where the attempts to fix the ATI
>> APIC 8254 timer issues were going to. Only later when it was finally
>> fixed properly was it backported to x86.
>
> I'm not sure what you mean here. The ATI timer fixes were done
> on both i386 and x86-64.

But why did it took so long to finally fix this when ATI has been making ch=
ipsets since 2001?
Even worse=2C why was the attempts to fix this issue going to the x86-64 br=
anch when ATI was making chipsets before the AMD Athlon 64 was even release=
d?

Yuhong Bao
 		 	   		  =0A=
_________________________________________________________________=0A=
Hotmail: Trusted email with powerful SPAM protection.=0A=
http://clk.atdmt.com/GBL/go/177141665/direct/01/=
