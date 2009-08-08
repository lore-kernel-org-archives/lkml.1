Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZHHBBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZHHBBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 21:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZHHBBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 21:01:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbZHHBBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 21:01:44 -0400
Date: Sat, 8 Aug 2009 03:01:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Christian Thaeter <ct@pipapo.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/2] hpfall: reduce risk that hpfall can do harm
In-Reply-To: <200907252055.16416.elendil@planet.nl>
Message-ID: <alpine.LNX.2.00.0908080301170.25797@wotan.suse.de>
References: <200907252055.16416.elendil@planet.nl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jul 2009, Frans Pop wrote:

> This patch was posted some time back by Christian and acked by Pavel, but
> was never picked up: http://lkml.org/lkml/2009/3/25/505.
> All I've done is cleaned up whitespace and the commit message.
> 
> The patch is on top of my patch to clean up checkpatch errors which is
> already in the trivial tree for .32. As this is only example code, I guess
> this could go through trivial too.

Applied to trivial queue as a documentation update, thanks Frans!

-- 
Jiri Kosina
SUSE Labs
