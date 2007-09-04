Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbXIDQcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbXIDQcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 12:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXIDQcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 12:32:21 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:37347 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753131AbXIDQcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 12:32:20 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc5
Date: Tue, 4 Sep 2007 19:32:03 +0300
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, axboe@kernel.dk,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <alpine.LFD.0.999.0708312343440.27951@evo.linux-foundation.org> <200709041911.03442.caglar@pardus.org.tr>
In-Reply-To: <200709041911.03442.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709041932.04220.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Again;

04 Eyl 2007 Sal tarihinde, S.Çağlar Onur şunları yazmıştı: 
> Hi;
>
> 01 Eyl 2007 Cts tarihinde, Linus Torvalds şunları yazmıştı:
> > So have fun, give it a go, and expect a quiet week next week.
>
> After upgrading -rc5 (i'm currently using linus's latest git + appArmor and
> bootsplash patchset) my CD/DVD-ROM suddenly disappeared :).
>
> caglar@zangetsu ~ $ diff -u rc4 rc5 | grep cd-rom -i
> -Sep  3 11:30:33 localhost kernel: [   19.328120] scsi 4:0:0:0: CD-ROM
> MATSHITA DVD-RAM UJ-851S  1.50 PQ: 0 ANSI: 5
> -Sep  3 11:30:33 localhost kernel: [   21.258819] Uniform CD-ROM driver
> Revision: 3.20
> -Sep  3 11:30:33 localhost kernel: [   21.258873] sr 4:0:0:0: Attached scsi
> CD-ROM sr0

Forget it :), it was a hardware problem caused by cdrom bay

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
