Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbZECWEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbZECWEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 18:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZECWEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 18:04:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51698 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbZECWEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 18:04:22 -0400
Date: Sun, 3 May 2009 23:04:22 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Mark WM8350 mask revision as readable to match
	silicon
Message-ID: <20090503220420.GA22353@sirena.org.uk>
References: <1241099069-17778-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20090503215728.GC3278@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503215728.GC3278@sortiz.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 11:57:29PM +0200, Samuel Ortiz wrote:
> On Thu, Apr 30, 2009 at 02:44:29PM +0100, Mark Brown wrote:

> > No impact unless someone has written additional kernel code.

> All 3 patches applied to my for-next branch, thanks.

At least the patch for the caching of volatile registers really ought to
go into 2.6.30 if possible - not having it breaks the audio driver for
the chip.
