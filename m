Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab0CBWkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:40:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:56390 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab0CBWkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:40:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=RHFU3F5XBphHmfDGyfUuJL8MxI3AqbqcOR51NxCx16Gr5qYQnesc03DXL0DQ5gNE9s
         OtzHf1u9hm+iiiRpPR5QFvtxBTBcTajVQwAC2iBzcf0+4TTcOkb7zPNDZTOZnQSgcho+
         amE2K9rnPHP/2PJVBhb+dGSW626e1ZbEpAo7c=
Date: Tue, 2 Mar 2010 14:39:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Michael Thayer <Michael.Thayer@Sun.COM>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1]: input: add support for VirtualBox touchscreen
 emulation to the Lifebook driver
Message-ID: <20100302223947.GC13499@core.coreip.homeip.net>
References: <1266923615.3602.85.camel@michael-laptop>
 <20100223175852.GA11301@core.coreip.homeip.net>
 <1266958533.3602.128.camel@michael-laptop>
 <20100224100206.GA5598@core.coreip.homeip.net>
 <1267011989.2831.30.camel@michael-laptop>
 <20100225101705.GF10823@core.coreip.homeip.net>
 <1267562688.2441.7.camel@michael-laptop>
 <20100302212812.GA13499@core.coreip.homeip.net>
 <1267567219.2441.12.camel@michael-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1267567219.2441.12.camel@michael-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 11:00:19PM +0100, Michael Thayer wrote:
> Le mardi 02 mars 2010 à 13:28 -0800, Dmitry Torokhov a écrit :
> > On Tue, Mar 02, 2010 at 09:44:48PM +0100, Michael Thayer wrote:
> > > it still provides a reasonable user experience until the user has installed our
> > > guest drivers.
> > 
> > It is your call but I would much rather if you worked on fixeng evdev to
> > work with your virtual device rather than having to install a new X
> > driver and going through the hoops trying to detect which one should be
> > used on a particular box. At least on Linux...
> That wouldn't really help us much here, as we are talking about distributions
> shipping X.Org Server 1.4 and earlier, and those distributions are no longer
> going to get that sort of update (in those cases in which they are still
> getting updates at all).  Legacy support if you like.
> 

You need to distribute something... Or do these older distros already
include your guest drivers?

-- 
Dmitry
