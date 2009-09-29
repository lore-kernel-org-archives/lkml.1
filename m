Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbZI2V36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbZI2V36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZI2V35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:29:57 -0400
Received: from mga06.intel.com ([134.134.136.21]:60089 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752699AbZI2V35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:29:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,475,1249282800"; 
   d="scan'208";a="452800830"
Date: Tue, 29 Sep 2009 23:31:57 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       michael.hennerich@analog.com
Subject: Re: [Uclinux-dist-devel] [PATCH v2] mfd: ADP5520 Multifunction LCD
 Backlight and Keypad Input Device Driver
Message-ID: <20090929213156.GB7567@sortiz.org>
References: <1253212036-29445-1-git-send-email-vapier@gentoo.org>
 <1253682664-27040-1-git-send-email-vapier@gentoo.org>
 <8bd0f97a0909291404v6d7f8a9dyb19fa8ad48f9484f@mail.gmail.com>
 <20090929141450.b2b36e4d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929141450.b2b36e4d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 02:14:50PM -0700, Andrew Morton wrote:
> On Tue, 29 Sep 2009 17:04:21 -0400
> Mike Frysinger <vapier.adi@gmail.com> wrote:
> 
> > On Wed, Sep 23, 2009 at 01:11, Mike Frysinger wrote:
> > > From: Michael Hennerich <michael.hennerich@analog.com>
> > >
> > > Base driver for Analog Devices ADP5520/ADP5501 MFD PMICs
> > 
> > could you check this out/pick up Andrew ?
> 
> Spose so.  Is Samuel not around?
I'm around, just too busy those days to look at mfd stuff. Sorry for the
latency...
I'll grab my mfd hat tomorrow, look at the various patches pending and update
my tree.

Cheers,
Samuel.
 
> Does this patch have any dependencies on other stuff we weren't told about?
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
