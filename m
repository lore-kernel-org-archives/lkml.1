Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZALNEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZALNEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 08:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbZALNDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 08:03:52 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:2821 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbZALNDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 08:03:51 -0500
Date: Mon, 12 Jan 2009 14:03:43 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Jan Dittmer <jdi@l4x.org>, Diego Calleja <diegocg@gmail.com>,
       linux-kernel@vger.kernel.org, eric.anholt@iintel.com, airlied@linux.ie
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Message-ID: <20090112130343.GA89729@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Dave Airlie <airlied@gmail.com>, Jan Dittmer <jdi@l4x.org>,
	Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
	eric.anholt@iintel.com, airlied@linux.ie
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com> <621d098f0901110551v5a05f69aqc4e06a6905989d6e@mail.gmail.com> <20090111222122.4d0cb146@diego-desktop> <21d7e9970901111339q705bcea4i44941bfd84a075fe@mail.gmail.com> <621d098f0901112342q353326b2k31c276e044ad9d0a@mail.gmail.com> <21d7e9970901120004t2dd68241x6b9533f489601109@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970901120004t2dd68241x6b9533f489601109@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 06:04:19PM +1000, Dave Airlie wrote:
> explicit VideoRAM is most likely ignored by xorg as well for Intel
> chipsets with the latest driver,

I'm going on a tangeant, but it would be nice if video drivers, intel
first among them, would stop ignoring user-provided configurations in
favour of firmwares, bioses, in-display roms and other things like
that that can be incorrect and not user-modifiable.  VideoRAM is one,
but there's also modeline, DPI...

  OG.
