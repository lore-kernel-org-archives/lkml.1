Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbXHPIP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbXHPIP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759510AbXHPIO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:14:59 -0400
Received: from webmailfront01.ispgateway.de ([80.67.16.111]:38417 "EHLO
	webmailfront01.ispgateway.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755603AbXHPIOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:14:54 -0400
X-Greylist: delayed 2078 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 04:14:54 EDT
Message-ID: <20070816093703.sndy0gg44gk0o0ko@webmail.df.eu>
Date: Thu, 16 Aug 2007 09:37:03 +0200
From: Clemens Ladisch <clemens@ladisch.de>
To: David Griffith <dgriffi@cs.csubak.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MOTU Fastlane USB MIDI interface
References: <Pine.GSO.4.55.0708100242000.25856@helios.cs.csubak.edu>
In-Reply-To: <Pine.GSO.4.55.0708100242000.25856@helios.cs.csubak.edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: domainFACTORY
X-Originating-IP: 213.238.46.206
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Griffith wrote:
> Does anyone here have or can borrow a MOTU Fastlane USB MIDI interface?
> I'm having a nasty time trying to nail down what's going wrong.  It seems
> that for kernels 2.6.17 and earlier, MIDI works fine through this
> interface.  After that, it doesn't.

What do you mean with "doesn't work"?  Does the kernel detect it?   
Does it appear
in /proc/asound/cards?  What happens if you try to use it?


Regards,
Clemens

