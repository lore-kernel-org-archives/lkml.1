Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZEDHsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZEDHsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 03:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZEDHsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 03:48:06 -0400
Received: from mga07.intel.com ([143.182.124.22]:55907 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753225AbZEDHsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 03:48:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,291,1239001200"; 
   d="scan'208";a="138818527"
Date: Mon, 4 May 2009 09:50:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@sirena.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Mark WM8350 mask revision as readable to match
	silicon
Message-ID: <20090504075020.GA3620@sortiz.org>
References: <1241099069-17778-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20090503215728.GC3278@sortiz.org> <20090503220420.GA22353@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503220420.GA22353@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 11:04:22PM +0100, Mark Brown wrote:
> On Sun, May 03, 2009 at 11:57:29PM +0200, Samuel Ortiz wrote:
> > On Thu, Apr 30, 2009 at 02:44:29PM +0100, Mark Brown wrote:
> 
> > > No impact unless someone has written additional kernel code.
> 
> > All 3 patches applied to my for-next branch, thanks.
> 
> At least the patch for the caching of volatile registers really ought to
> go into 2.6.30 if possible - not having it breaks the audio driver for
> the chip.
Yes, I'll include it to one of my 2.6.30 pull requests.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
