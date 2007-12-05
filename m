Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbXLEXXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbXLEXXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 18:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXLEXXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 18:23:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:50281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbXLEXXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 18:23:24 -0500
Date: Thu, 6 Dec 2007 00:23:23 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 17/18] mm: remove nopage
Message-ID: <20071205232322.GA5617@wotan.suse.de>
References: <20071205071547.701344000@nick.local0.net> <20071205071628.547577000@nick.local0.net> <20071205144700.729a0c98.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205144700.729a0c98.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 02:47:00PM -0800, Andrew Morton wrote:
> On Wed, 05 Dec 2007 18:16:04 +1100
> npiggin@suse.de wrote:
> 
> > Nothing in the tree uses nopage any more. Remove support for it in the
> > core mm code and documentation (and a few stray references to it in comments).
> 
> I'll duck this for now.  It's going to take a long time to get all those
> other patches merged given my usual ~75% dropped-on-the-floor rate from
> subsystem maintainers.  Please resend when mainline is nopage-free.

Sure, no problem.
