Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbZGPHad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbZGPHad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZGPHac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:30:32 -0400
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:41684 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbZGPHac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:30:32 -0400
Message-ID: <4A5ED714.7010304@blueyonder.co.uk>
Date: Thu, 16 Jul 2009 08:30:28 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Sid Boyce <sboyce@blueyonder.co.uk>
Subject: OpenSolaris boot failure with KVM and VirtualBox
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I first tried using kernel 2.6.31-rc1 on openSUSE 11.2 Milestone1 on a
4P box. All other VM's, Windows and Linux work, currently running
openSUSE 11.2 Milestone 3 with 2.6.31-rc3. Verified the .iso is good.
Error message
=============
Booting 'OpenSolaris 2009.06'
kernel$ /platform/i86pc/kernel/$ISADIR/unix
loading '/platform/i86pc/kernel/$ISADIR/unix' ...
cpu: 'AuthenticAMD' family 16 model 4 step 2 ...
[BIOS accepted mixed-mode target setting!]
  [Multiboot-kernel, loadaddr=0xbffe38, text-and-data=0x1b1ff0, bss=0x0,
entry=0xc00000]
'platform/i86pc/kernel/amd64/unix' is loaded
module$ /boot/$ISADIR/x86.microroot
loading '/boot/$ISADIR/x86.microroot' ...
Error 15: File not found
Press any key to continue ...
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

