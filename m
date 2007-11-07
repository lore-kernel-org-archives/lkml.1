Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbXKGXNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbXKGXNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758626AbXKGXNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:13:23 -0500
Received: from zakalwe.fi ([80.83.5.154]:54063 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbXKGXNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:13:22 -0500
Date: Thu, 8 Nov 2007 01:13:21 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org
Subject: Re: net: skge breakage on 2.6.24-rc1
Message-ID: <20071107231321.GE8865@zakalwe.fi>
References: <20071107214621.GA8865@zakalwe.fi> <20071107215348.GB8865@zakalwe.fi> <200711072350.30645.rjw@sisk.pl> <20071107150621.f2da7f69.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20071107150621.f2da7f69.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 03:06:21PM -0800, Andrew Morton wrote:
> > On Wed, 7 Nov 2007 23:50:30 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > On Wednesday, 7 of November 2007, Heikki Orsila wrote:
> > > On Wed, Nov 07, 2007 at 11:46:21PM +0200, Heikki Orsila wrote:
> > > > After some bisecting, I found that net skge driver broke on
> > > > 
> > > > commit 7fb7ac241162dc51ec0f7644d4a97b2855213c32
> 
> 
> Thanks for doing the bisection.  It's a good idea to cc the author of the
> offending patch after having done this.

Sorry, I just forgot this time. Just after the bug report I did mail 
the author in private (out of the list).

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
