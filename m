Return-Path: <linux-kernel-owner+w=401wt.eu-S933071Ab0AFXXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab0AFXXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932979Ab0AFXX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:23:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932665Ab0AFXX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:23:28 -0500
Date: Thu, 7 Jan 2010 00:23:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefan Weil <weil@mail.berlios.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linuxppc-dev@ozlabs.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH] Fix spelling in comments and documentation
In-Reply-To: <20100106151144.e58bdd4a.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1001070022491.2277@pobox.suse.cz>
References: <1262819032-16644-1-git-send-email-weil@mail.berlios.de> <20100106151144.e58bdd4a.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010, Andrew Morton wrote:

> > Replace platfrom -> platform.
> > 
> > This is a frequent spelling bug.
> 
> I have a "no spelling fixes unless they're in documentation or printks"
> policy ;)
> 
> trivial@kernel.org would be a suitable recipient for this patch.

Yup, I am usually applying all the comment typo fixes, as it makes the 
source more grepping-friendly.

Applied, thanks Stefan.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
