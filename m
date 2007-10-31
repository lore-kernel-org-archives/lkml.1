Return-Path: <linux-kernel-owner+w=401wt.eu-S1759104AbXJaLHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104AbXJaLHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbXJaLHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:07:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37453 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745AbXJaLHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:07:01 -0400
Date: Wed, 31 Oct 2007 12:06:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Rosenstand <mark@borkware.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slightly OT: Unable to wake-up after suspend
Message-ID: <20071031110653.GB2381@elf.ucw.cz>
References: <1189519845.27446.40.camel@abfahrt.borkware.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189519845.27446.40.camel@abfahrt.borkware.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-09-11 16:10:45, Mark Rosenstand wrote:
> I just gave the CentOS 5.0 live CD a spin and wanted to see if suspend
> worked. The system did suspend but I'm unable to make it wake-up again,
> at all.
> 
> I've tried unplugging the power cord, resetting CMOS, removing the BIOS
> battery and all RAM. The system shows no sign of life except the
> motherboard LED, unless I power it on with the CLRTC jumper activated in
> which case the CPU FAN and harddisk starts, but still no monitor signal.
> 
> This is a Asus K8V-X motherboard[1] with ECC RAM and the system has been
> rock solid for almost 3 years despite daily abuse (build machine).
> 
> Any advice would be greatly appreciated.

Did this get resolved somehow? "Suspend killed machine" sounds scary.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
