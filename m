Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZA1VTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZA1VTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZA1VTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:19:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56998 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZA1VTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:19:05 -0500
Date: Wed, 28 Jan 2009 21:18:44 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, tony@atomide.com,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: OMAP clock fast-forward: an introduction to six series
Message-ID: <20090128211844.GI23301@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.00.0901281310590.14710@utopia.booyaka.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901281310590.14710@utopia.booyaka.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 01:22:22PM -0700, Paul Walmsley wrote:
> Per rmk's preferences, some patches have been 'compressed.' That is, some 
> fix patches have been rolled into a single patch with the original.  To 
> ease cross-referencing with the linux-omap git tree, original commit IDs 
> have been inserted into the patch messages.  Also, what would have been an 
> extremely long series has been split into six smaller, cumulative, roughly 
> thematic patch series.  If requested, I would be pleased to simply send 
> one large series of the original, uncompressed patches.  Thanks to the git 
> and stgit authors and contributors: without those tools, this process 
> would have been nearly impossible.

Since this patch series was only really meant for me to do some follow-on
work on it (to merge it into my tree) is it really necessary to submit
this 70 patch series via slow email via several mailing lists?

At the rate they're coming through I might have the entire set by
midnight...
