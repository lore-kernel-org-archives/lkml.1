Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZC2TFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZC2TFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 15:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZC2TFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 15:05:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47756 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbZC2TFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 15:05:44 -0400
Date: Sun, 29 Mar 2009 20:05:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: firmware patches
Message-ID: <20090329190518.GW3051@decadent.org.uk>
References: <1238340694.2989.8.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238340694.2989.8.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on separation of firmware with my Debian hat on.  Please use
this email address or <benh@debian.org> in connection with that work.

On Sun, 2009-03-29 at 21:01 +0530, Jaswinder Singh Rajput wrote:
> Hello Ben,
> 
> I am glad that you pick up Radeon and Typhoon firmware patches and
> applied to main stream.
>
> here is my old firmware tree:
> http://git.kernel.org/?p=linux/kernel/git/jaswinder/firm-jsr-2.6.git;a=shortlog
> 
> If you want it is still having various SCSI, network and other firmware
> patches which you can pickup and apply to main stream some of them are
> already applied in linux-next you can take help from them and also apply
> them to main stream.

So far as I know, all firmware is now separated out in the Debian
packages, with the exception of some that just sneaked in through
drivers/staging.  The patches we are applying to 2.6.29 have all been
accepted into a tree destined for 2.6.30, except for the DRM drivers
(mga, r128 and radeon).  Are you aware of anything we've missed?

Ben.

