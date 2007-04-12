Return-Path: <linux-kernel-owner+w=401wt.eu-S1030837AbXDLWix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030837AbXDLWix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 18:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030838AbXDLWix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 18:38:53 -0400
Received: from waste.org ([66.93.16.53]:47527 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030837AbXDLWiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 18:38:51 -0400
Date: Thu, 12 Apr 2007 17:25:48 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Tim Yamin <plasmaroo@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH UPDATE] deflate stack usage in lib/inflate.c
Message-ID: <20070412222547.GA11166@waste.org>
References: <461DED14.1070603@goop.org> <461E9BAD.8050202@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461E9BAD.8050202@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 01:50:54PM -0700, Jeremy Fitzhardinge wrote:
> -#define HEAP_SIZE             0x3000
> +#define HEAP_SIZE             0x4000

There are a bunch more of these that'll need fixing.

-- 
Mathematics is the supreme nostalgia of our time.
