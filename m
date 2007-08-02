Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbXHBB3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbXHBB3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 21:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbXHBB3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 21:29:10 -0400
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67]:55819 "EHLO
	webmail-outgoing.us4.outblaze.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016AbXHBB3J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 21:29:09 -0400
X-Greylist: delayed 27073 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2007 21:29:09 EDT
X-OB-Received: from unknown (205.158.62.62)
  by wfilter2.us4.outblaze.com; 2 Aug 2007 01:17:45 -0000
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "Ash Willis" <ashwillis@programmer.net>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, tiwai@suse.de, rafalbilski@interia.pl
Date: Wed, 1 Aug 2007 20:17:45 -0500
Subject: Re: CS5530 Alsa driver fails
X-Originating-Ip: 79.65.93.93
X-Originating-Server: ws1-7.us4.outblaze.com
Message-Id: <20070802011745.B6DA0115449@ws1-7.us4.outblaze.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> the VGA video. If your box has VSA2 then VSA2 firmware has some kind of
> hooks to allow a native sound driver to take over and to reroute the
> interrupts without SB emulation. I don't have the docs for VSA2 but the
> horribly big natsemi provided audio driver does show how to do it.
> 

I wouldn't mind porting VSA2 support to ALSA. I just don't have test
hardware. Do you happen to know any examples of hardware that run VSA2
firmware or is it just a case of a firmware update?

> Alan

Thanks,

Ash

-- 
We've Got Your Name at http://www.mail.com!
Get a FREE E-mail Account Today - Choose From 100+ Domains

