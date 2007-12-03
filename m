Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbXLCPTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbXLCPTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbXLCPTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:19:24 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:43491 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbXLCPTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:19:24 -0500
Date: Mon, 3 Dec 2007 16:19:23 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Peter Stahlir <peter.stahlir@googlemail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: cgit for kernel.org
In-Reply-To: <47541701.9060705@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0712031603320.11746@fbirervta.pbzchgretzou.qr>
References: <fbe8b1780712030304q14ed9e62wb0da75d8f4884c0b@mail.gmail.com>
 <Pine.LNX.4.64.0712031331580.21880@fbirervta.pbzchgretzou.qr>
 <47541701.9060705@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 3 2007 15:47, Stefan Richter wrote:
>Jan Engelhardt wrote:
>> On Dec 3 2007 12:04, Peter Stahlir wrote:
>>>I suggest setting up cgit for kernel.org
>>>cgit is a fast web interface for git.
>>>It is located at http://hjemli.net/git/cgit/
>>>I tried it at http://cgit.freedesktop.org/
>>>and it feels much snappier than gitweb.
>> 
>> cgit looks so bare.
>
>This is a compliment to cgit, right?  Anyway, the UI looks OK to me.

Repository overview.
	CGIT: http://cgit.freedesktop.org/
	GITWEB: http://git.kernel.org/

	Remarks:
	cgit is lacking the links "shortlog", "log", "tree" and "git"
	which gitweb prints for each repository line.

Inside a repository.
	CGIT: http://cgit.freedesktop.org/hal/
	GITWEB:	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary

	Remarks:
	In cgit, the left gray panel went by quite unnoticed, possibly as an
	unintended reaction to the omnipresent ad positions in Internet
	websites, or because it is "just" the menu. Compare with the GNU
	Savannah site, which also has the menu on the left side, which I
	also used quite rarely (only to login), everything else happens in
	the white pane.

Clicking on a commit.
	CGIT: http://cgit.freedesktop.org/hal/commit/?id=b8f72cec53415ebc2d32805b049dcc94cef4a854
	GITWEB: http://git.kernel.org/?p=linux/kernel/git/jgarzik/misc-2.6.git;a=commit;h=8c27eba54970c6ebbb408186e5baa2274435e869

	Remarks:
	cgit comes with a diffstat. Not that I look at diffstats all that
	often anyway. Still need to click on "(diff)" go get a diff.

	Filenames are displayed with monospace font in gitweb :)
	Clicking on the commit actually shows its diff in gitweb.

Final remark:
	gitweb has the warmer colors.
