Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYHFVdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYHFVdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764100AbYHFVXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:23:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:55388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764182AbYHFVXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:23:49 -0400
Date: Wed, 6 Aug 2008 14:23:47 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sunil Mushran <sunil.mushran@oracle.com>, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] ocfs2/cluster/tcp.c: make some functions static
Message-ID: <20080806212347.GW28014@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <20080806211112.GP1702@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806211112.GP1702@cs181140183.pp.htv.fi>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 12:11:12AM +0300, Adrian Bunk wrote:
> Commit 0f475b2abed6cbccee1da20a0bef2895eb2a0edd
> (ocfs2/net: Silence build warnings) made sense
> as far as it fixed compile warnings, but it was
> not required that it made the functions global.

Great, thanks Adrian.
	--Mark

--
Mark Fasheh
