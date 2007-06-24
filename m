Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbXFXSnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbXFXSnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 14:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbXFXSnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 14:43:15 -0400
Received: from fallback.us4.outblaze.com ([205.158.62.120]:54034 "EHLO
	fallback.us4.outblaze.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbXFXSnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 14:43:14 -0400
X-OB-Received: from unknown (205.158.62.62)
  by wfilter2.us4.outblaze.com; 24 Jun 2007 18:35:26 -0000
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "Ash Willis" <ashwillis@programmer.net>
To: linux-kernel@vger.kernel.org
Date: Sun, 24 Jun 2007 13:35:26 -0500
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
X-Originating-Ip: 212.139.44.104
X-Originating-Server: ws1-7.us4.outblaze.com
Message-Id: <20070624183526.B1E7F1158CD@ws1-7.us4.outblaze.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kloczek,
The fact that it is now open source does mean that it's a suitable replacement.

If you actually want a productive discussion, you'd be better off making an
attempt at describing exactly _why_ ALSA is 'crap' and how in your opinion OSS
overcomes ALSA's shortfalls.

IMHO, it would be far more realistic and managable to look at the OSS codebase
and use it to make improvements to ALSA. I'm looking into one or two issues
myself and I've mentioned looking at the OSS code for possible improvements on
the alsa-devel list. I think it's generally agreed that OSS can't do much at all
that ALSA doesn't already do. Sure, if you've been smoking crack, you might want
to rip out ALSA and replace it with OSS to gain some minor functionality but
you'd also lose functionality in the process.

Unless you can describe how the actual architecture of ALSA is inferior and not
just complain about some particular device not being fully supported, the best
idea is clearly to port any lacking functionality from OSS -> ALSA. In the case
that you can actually provide valid reasons for ALSA's inferiority, I shall
respectfully eat my hat :)

Either way, have bug reports been filed for areas of ALSA that you are unhappy
with?

Ash

-- 
Get a Free E-mail Account at Mail.com!
Choose From 100+ Personalized Domains
Visit http://www.mail.com today

