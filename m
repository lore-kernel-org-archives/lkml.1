Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbYFGKOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbYFGKOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 06:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbYFGKOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 06:14:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34197 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbYFGKOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 06:14:37 -0400
Date: Sat, 7 Jun 2008 11:14:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org, mzxreary@0pointer.de
Subject: Re: [PATCH] Add backlight driver for Nvidia-based Apple Macbook Pros
Message-ID: <20080607101433.GA572@srcf.ucam.org>
References: <20080607025436.GB24254@srcf.ucam.org> <20080606230745.304d116b.akpm@linux-foundation.org> <20080607095839.GA803@srcf.ucam.org> <84144f020806070305q33dd341wfbb36138d7b533a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020806070305q33dd341wfbb36138d7b533a@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2008 at 01:05:23PM +0300, Pekka Enberg wrote:
> Hi Matthew,
> 
> On Fri, Jun 06, 2008 at 11:07:45PM -0700, Andrew Morton wrote:
> >> Did this patch have appropriate attribution and signoffs?
> 
> On Sat, Jun 7, 2008 at 12:58 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Pommed is GPLv2.
> 
> Andrew has required signoffs from all copyright holders of a patch in
> the past regardless of that.

SubmittingPatches says (in part):

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

If that's not sufficient, then the documentation needs fixing. It's also 
not current practice, as far as I can tell - did ath5k have sign-offs 
from the BSD people?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
