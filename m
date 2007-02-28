Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbXB1Vzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbXB1Vzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932488AbXB1Vzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:55:35 -0500
Received: from mtl.rackplans.net ([69.90.0.18]:49242 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486AbXB1Vze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:55:34 -0500
Date: Wed, 28 Feb 2007 16:55:32 -0500 (EST)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Charles Shannon Hendrix <shannon@widomaker.com>
cc: linux-kernel@vger.kernel.org
Subject: solved Re: 2.6.20 SATA error
In-Reply-To: <20070228163204.16c21f29@daydream.goid.lan>
Message-ID: <Pine.LNX.4.64.0702281649590.5096@mtl.rackplans.net>
References: <Pine.LNX.4.64.0702280739510.21113@mtl.rackplans.net>
 <20070228111412.4d8a2d72@daydream.goid.lan> <Pine.LNX.4.64.0702281220510.12067@mtl.rackplans.net>
 <20070228163204.16c21f29@daydream.goid.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Charles Shannon Hendrix wrote:

> On Wed, 28 Feb 2007 13:25:00 -0500 (EST)
> Gerhard Mack <gmack@innerfire.net> wrote:
> 
>  
> > > In another thread, I think they were saying it was either a SATA chipset
> > > driver bug, or a problem in libata core.
> > 
> > I also have an nforce4.
> 
> On another mailing list, someone with an Intel chipset is reporting the same
> problem, and also that others without nforce chipsets are seeing it.

I was reaching inside my computer to check something and heared the thing 
click and got the same error message.

Turns out the adaptor that goes between SATA drive and the old style power 
connector was loose on the drive side.  Doesn't seem to me like it was 
very snug fitting to begin with.  I changed it to one of the proper SATA 
connectors comming off the power supply and it doesn't do that anymore.

Sorry for the false alarm, 

	Gerhard

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
