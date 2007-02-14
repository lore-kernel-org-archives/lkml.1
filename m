Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXBNWAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXBNWAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932668AbXBNWAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:00:34 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:39676 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664AbXBNWAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:00:33 -0500
Date: Wed, 14 Feb 2007 22:58:42 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Dax Kelson <dax@gurulabs.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linus' laptop and Num lock status
In-Reply-To: <1171488840.3706.78.camel@mentorng.gurulabs.com>
Message-ID: <Pine.LNX.4.61.0702142257490.19368@yvahk01.tjqt.qr>
References: <1171479361.3706.48.camel@mentorng.gurulabs.com> 
 <Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org> 
 <20070214202144.1ddb930f.khali@linux-fr.org> 
 <Pine.LNX.4.64.0702141130340.20368@woody.linux-foundation.org>
 <1171488840.3706.78.camel@mentorng.gurulabs.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Feb 14 2007 14:34, Dax Kelson wrote:
>
>I checked, and looking at offset 0x497 seems to work fine on a couple of
>systems with USB keyboards.

Probably just because legacy mode was enabled. Plus I wonder what 0x497 will
return when there is actually more than one USB keyboard connected at boot.



Jan
-- 
ft: http://freshmeat.net/p/chaostables/
