Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbXFVJpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbXFVJpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 05:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbXFVJpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 05:45:45 -0400
Received: from ns.firmix.at ([62.141.48.66]:36367 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbXFVJpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 05:45:44 -0400
Subject: Re: Please release a stable kernel Linux 3.0
From: Bernd Petrovitsch <bernd@firmix.at>
To: =?ISO-8859-1?Q?Zolt=E1n?= HUBERT <zoltan.hubert@zzaero.com>
Cc: Xavier Bestel <xavier.bestel@free.fr>, linux-kernel@vger.kernel.org
In-Reply-To: <1182503978.23588.7.camel@frg-rhel40-em64t-04>
References: <200706212349.54983.zoltan.hubert@zzaero.com>
	 <1182503978.23588.7.camel@frg-rhel40-em64t-04>
Content-Type: text/plain; charset=UTF-8
Organization: Firmix Software GmbH
Date: Fri, 22 Jun 2007 11:45:29 +0200
Message-Id: <1182505529.27891.31.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -1.094 () AWL
X-Firmix-Spam-Status: No, hits=-1.094 required=5
X-Spam-Score: -1.094 () AWL
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 11:19 +0200, Xavier Bestel wrote:
> On Thu, 2007-06-21 at 23:49 +0200, Zoltán HUBERT wrote:
> > While some of you dislike 
> > closed source drivers, the choices "we users" face are:
> > - closed source drivers with closed source OS
> > - closed source drivers with open source OS

You forgot the third, correct, way to do to it: buy hardware where
open-source drivers exist if you don't want to live the above (and yes,
there are even open source graphic cards and WLAN drivers out there).

You didn't, tough luck. You could actually help driver developers if
only with testing new drivers versions.

> > Please consider that we are living in a REAL world, and not 
> > Disney-Land.

Yes, please also consider this and get rid of the "I'm an end user,
everything I do is right, I can demand what I want, everyone else must
follow for free and I need not do anything" attitude.

The usual alternatives include (but are not limited to):
- find someone else to fix *your* problems (it is up to you, how to
   motivate that being. "Money" is not the only motivation in the world
   but it sometimes works).
   Just demanding, whining and ranting on public mailing list doesn't
   motivate - at least not me.
- pay someone indirectly by buying a plug-n-play OS
- buy hardware with "Linux" pre-installed with the promise that
   everything works (and if something doesn't work, you should be able to
   give the hardware back or get a replacement or ...).
   Even if the pre-installed "Linux" doesn't fit you can install another
   one.
   If you really dislike closed source drivers, you better check that that
   hardware doesn't need ndiswrapper though. God knows what sales people
   tell you to sell a thing.
   Several shops hereover (in .at) actually offer to boot from a Live-CD
   (especially with laptops) so that one can see if and what is working
   or not.
- as mentioned above, buy hardware with parts where open source drivers
   exist
Probably the last two parts imply that it is not as cheap as the next
"special price" hardware (but think about "why should  a store sell
hardware cheaper than others and/or before?").

> Strange, I'm currently using this option:
> - open source drivers with open source OS
> and I'm sure I'm not living in Disney-Land.

Yes, but then you have to think before buying the next cheap hardware
and wonder afterwards that there are not 20 kernel developers eagerly
waiting to write a driver for a brand-new piece of hardware without any
documentation (except the products name).

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


