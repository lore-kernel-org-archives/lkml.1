Return-Path: <linux-kernel-owner+w=401wt.eu-S1761097AbXHIXRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761097AbXHIXRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 19:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbXHIXRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 19:17:17 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:8181 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbXHIXRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 19:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=A4J8Dv+q3ZQvUO8B+g6c1t0AAZXjkpSEh1+J9YnykQp+GTOLh6Bv1WrhMMZ0eokq6Bc1kzTjM3eGtEWvZIwFFootl0LR7jV0scJjx+9bx8T69BtfjSdAJTVIgLdn5Gr5AoOFas8Tywb3vLZw1mLqFcoJXufCuX4bosMIdWqcjIE=
Message-ID: <7fedbc910708091617o7ae25fd8i36e7ec32c2b9ba86@mail.gmail.com>
Date: Fri, 10 Aug 2007 01:17:14 +0200
From: shacky <shacky83@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Unable to handle kernel paging request at virtual address
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
I installed Ubuntu 7.04 and then upgraded to the future 7.10 on my
system based on an Asus Pundit barebone with 512 mb RAM and 120 Gb IDE
hard disk.
The system works without any problem, but when I try to shutdown or
restart the system, after a while during the shutdown process, the
system hangs and I see this error:

[87.935473] BUG: unable to handle kernel paging request at virtual
address 6d207972
[...........] printing eip:
[...........] 6d207972
[...........] *pde = 00000000
[...........] Oops: 000 [#2]
[...........] SMP
[...........] Modules linked in: bluetooth capability lirc_dev
speedstep_lib cpufreq_powersave cpufreq_stats cpufreq_userspace
cpufreq_ondemand cpufreq_conservative freq_table video container sbs
button dock ac battery ipv6 sbp2 lp fuse snd_emu10k1_synth
snd_emux_synth snd_seq_virmidi snd_seq_midi_emul  [....] etc.

I'm using the kernel 2.6.22.

I'm omitting the rest of the error because it is very very long and I
have to rewrite it because I can't copy&paste it. If you need some
other information please ask. :-)

Could you help me, please? What could be the problem?

Thank you very much!
Bye.
