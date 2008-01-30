Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbYA3GtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbYA3GtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 01:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYA3GtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 01:49:11 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:33313 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYA3GtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 01:49:10 -0500
Date: Wed, 30 Jan 2008 07:49:09 +0100
From: Andreas Mohr <andim2@users.sourceforge.net>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: andi@lisas.de, e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, bunk@kernel.org
Subject: Re: [RFC/PATCH] e100 driver didn't support any MII-less PHYs...
Message-ID: <20080130064909.GA19793@rhlx01.hs-esslingen.de>
Reply-To: andi@lisas.de
References: <20071228235118.GA31059@rhlx01.hs-esslingen.de> <477732A5.5020501@intel.com> <20080101200908.GA14805@rhlx01.hs-esslingen.de> <20080129230315.GA13389@rhlx01.hs-esslingen.de> <479FB225.7090604@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479FB225.7090604@intel.com>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 29, 2008 at 03:09:25PM -0800, Kok, Auke wrote:
> Andreas Mohr wrote:
> > Perhaps it's useful to file a bug/patch
> > on http://sourceforge.net/projects/e1000/ ? Perhaps -mm testing?
> 
> I wanted to push this though our testing labs first which has not happened due to
> time constraints - that should quickly at least confirm that the most common nics
> work OK after the change with your patch. I'll try and see if we can get this
> testing done soon.

Oh, full-scale regression testing even? Nice idea...
Would optionally be even better if during hardware tests one could also
dig out some i82503-based card (or additional MII-less cards?)
since I didn't really make any effort yet to try to make them all
recognized/supported by my patch already (would have been out of scope anyway
since I have this single card only).

Thanks a lot,

Andreas Mohr
