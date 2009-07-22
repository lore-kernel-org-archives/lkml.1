Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbZGVJ6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbZGVJ6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZGVJ6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:58:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48382 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753131AbZGVJ6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:58:05 -0400
Date: Wed, 22 Jul 2009 10:58:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/6] regulator: Add regulator_get_exclusive() API
Message-ID: <20090722095803.GB21171@rakim.wolfsonmicro.main>
References: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248209397.4333.50.camel@brutus>
 <4A667231.3020809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A667231.3020809@gmail.com>
X-Cookie: Biology grows on you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 09:58:09AM +0800, Eric Miao wrote:
> Daniel Ribeiro wrote:

> > Can you update pxamci.c and twl4030-mmc.c to make use of this new API?

> I think that deserves another two patches for making use of this
> new API.

Due to my workload, the cross tree merge issues and my lack of any test
hardware I wasn't in a hurry to do that myself - probably not until
after the merge window.  It'd probably be as easy for people with
relevant systems to do the updates.
