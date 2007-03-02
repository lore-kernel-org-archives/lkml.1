Return-Path: <linux-kernel-owner+w=401wt.eu-S2992697AbXCBWsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992697AbXCBWsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992699AbXCBWse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:48:34 -0500
Received: from smtp.ono.com ([62.42.230.12]:46893 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992697AbXCBWse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:48:34 -0500
Date: Fri, 2 Mar 2007 23:48:31 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Data files for new microcode interface
Message-ID: <20070302234831.7c1b7ff3@werewolf-wl>
X-Mailer: Claws Mail 2.8.0cvs8 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I get this messages on my syslog:

Mar  2 23:33:41 werewolf-wl firmware.sh[4088]: Cannot find  firmware file 'intel-ucode/0f-02-09'
Mar  2 23:33:41 werewolf-wl firmware.sh[4084]: Cannot find  firmware file 'intel-ucode/0f-02-09'
Mar  2 23:33:41 werewolf-wl firmware.sh[4092]: Cannot find  firmware file 'intel-ucode/0f-02-09'
Mar  2 23:33:41 werewolf-wl kernel: IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
Mar  2 23:33:41 werewolf-wl firmware.sh[4096]: Cannot find  firmware file 'intel-ucode/0f-02-09'

>From what I undestand, the old interface for microcode still works, but
I would like to move to the new one. I suppose I have to put the data
under /lib/firmware/intel-ucode/0f-02-09,  but where can I get the files ?
Do I just copy the file from old microcode_ctl package from Tigran ?
Or is the file in a different format ?

TIA

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam01 (gcc 4.1.2 20070115 (prerelease) (4.1.2-0.20070115.1mdv2007.1)) #1 SMP PREEMPT
