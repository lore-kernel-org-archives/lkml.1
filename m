Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbZHLHZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbZHLHZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 03:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZHLHZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 03:25:05 -0400
Received: from smtp.nokia.com ([192.100.122.233]:52737 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZHLHZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 03:25:04 -0400
Date: Wed, 12 Aug 2009 10:24:37 +0300
From: "Vignatti Tiago (Nokia-D/Helsinki)" <tiago.vignatti@nokia.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jesse Barnes <jesse.barnes@intel.com>, Dave Airlie <airlied@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>
Subject: Re: [PATCH] vga: implements VGA arbitration on Linux
Message-ID: <20090812072437.GA6453@cachaca>
Reply-To: tiago.vignatti@nokia.com
References: <1249969927-884-1-git-send-email-airlied@gmail.com> <20090811161746.7b8878aa@jbarnes-g45> <1250059688.15143.6.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250059688.15143.6.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 12 Aug 2009 07:24:39.0491 (UTC) FILETIME=[F3FCC130:01CA1B1D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 08:48:08AM +0200, Benjamin Herrenschmidt wrote:
> On Tue, 2009-08-11 at 16:17 -0700, Jesse Barnes wrote:
> 
> > Ok, applied this to my linux-next branch, but I'd like to get Ben's
> > s-o-b before pushing it to Linus.
> 
> Well, S-O-B is if the code went through my hands... though in this case
> I wrote the original version so I suppose it did :-) An ack for sure.
> 
> Let me have a look, I'll come back to you asap.

Ohh, I feel more comfortable if the patches come with Ben's authorship. Please
do it Dave because it makes more sense (and S-O-B by me).


Cheers,

            Tiago
