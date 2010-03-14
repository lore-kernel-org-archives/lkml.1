Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab0CNLYi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 07:24:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:32215 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab0CNLYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 07:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=roewfYx+GFpn0HU5Y178PN4oHj5gQ8WbFGshvcrGB5+o8fUpMNVScZfgMirvgDTI7C
         MXhAp24LcHNZXoxqTV/wtLU5dsWIfUZnwi88DVzDPeq7TG7WximDvmjPlWCKIbzCLkMr
         k0M7BPu5Q19hUJ4gVKSwsamIaBO5SJ5RDTwmw=
Date: Sun, 14 Mar 2010 13:24:29 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: 2.6.34-rc1: Badness at fs/proc/generic.c:316
Message-ID: <20100314112428.GA4142@x200>
References: <alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>
 <20100314065526.GA5353@x200>
 <alpine.DEB.2.01.1003140336280.5493@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1003140336280.5493@bogon.housecafe.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 03:39:39AM -0700, Christian Kujau wrote:
> On Sun, 14 Mar 2010 at 08:55, Alexey Dobriyan wrote:
> > > device-tree: Duplicate name in /cpus/PowerPC,G4@0, renamed to "l2-cache#1"
> > > name 'pulses/rev'
> > 
> > Uh-oh.
> 
> Uh-oh? :-)
> 
> >> Is this something to worry about? The machine seems to run fine so far...
> > 
> > Runtime behaviour remains the same, it's just new warning message.
> 
> So...the laptop probably won't blow up before -rc2 is out? :-)

Defitely not.

Post "find /proc/device-tree" output.
