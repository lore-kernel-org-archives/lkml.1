Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbXBVQtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbXBVQtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbXBVQtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:49:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33692 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbXBVQtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:49:41 -0500
Date: Thu, 22 Feb 2007 16:49:36 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH]
In-Reply-To: <1172109206.4217.61.camel@daplas>
Message-ID: <Pine.LNX.4.64.0702221648540.29542@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0702212105280.20620@pentafluge.infradead.org> 
 <1172106234.4217.50.camel@daplas>  <Pine.LNX.4.64.0702220119060.17121@pentafluge.infradead.org>
 <1172109206.4217.61.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Antonino A. Daplas wrote:

> On Thu, 2007-02-22 at 01:35 +0000, James Simmons wrote:
> > > On Wed, 2007-02-21 at 21:23 +0000, James Simmons wrote:
> 
> > > If this is an attempt to consolidate, I don't see the 'brightness'
> > > hook of backlight and lcd.
> > > 
> > > If this is not a consolidation, why don't we just extend the lcd class?
> > 
> > Its is a replacement for lcd. Is brightness universal for all display 
> > types?
> 
> Well, if you're adding a universal interface, you need hooks for more
> than that (brightness, contrast, hue, saturation, tint, etc).  Then we
> just let the drivers cherry pick from the list on what it's going to
> support.

Ah. Thats the power of sysfs groups :-)

