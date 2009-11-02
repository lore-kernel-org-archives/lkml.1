Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZKBNnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZKBNnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZKBNnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:43:15 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37223 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754232AbZKBNnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:43:15 -0500
X-Sasl-enc: CvLK3iZxjTq/2Ud1iK0xNl96cYhGMkmXq88YNIj1qQxy 1257169399
Date: Mon, 2 Nov 2009 11:43:17 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, nut-upsuser@lists.alioth.debian.org,
       bruce.w.allan@intel.com, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.31.4: Intel P55 Chipset BUG [usbhid-raw/devices/broken?]
 [tested 3 different UPS']
Message-ID: <20091102134317.GB2687@khazad-dum.debian.net>
References: <alpine.DEB.2.00.0910311847530.5522@p34.internal.lan>
 <Pine.LNX.4.44L0.0911011151270.399-100000@netrider.rowland.org>
 <20091101175216.GA24436@one-eyed-alien.net>
 <alpine.DEB.2.00.0911011613270.2767@p34.internal.lan>
 <20091102004940.GD24436@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102004940.GD24436@one-eyed-alien.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Nov 2009, Matthew Dharm wrote:
> On Sun, Nov 01, 2009 at 04:18:40PM -0500, Justin Piszcz wrote:
> > I do not use any hubs in this environment, everything is directly 
> > attached to the motheboard.  Per Matthew (noted below) when I
> > mention hub I am talking about your typical USB hub one would
> > attach to a USB port on the board, not the integrated one on the
> > motherboard.  Everything is directly attached from the motherboard
> > to each respective device.
> > 
> > MOBO -> UPS
> > MOBO -> KBD
> > MOBO -> etc
> 
> Just to be clear, the hub isn't "on the motherboard".  It's actually in the
> P55 silicon itself.  It's not a separate chip or anything; it's part of the
> PCH design.

And, if it is broken, maybe the brokenness is listed in the PCH errata?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
