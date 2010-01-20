Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349Ab0ATXSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0ATXSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311Ab0ATXSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:18:14 -0500
Received: from cobra.newdream.net ([66.33.216.30]:40664 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0ATXSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:18:14 -0500
Date: Wed, 20 Jan 2010 15:18:49 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Julia Lawall <julia@diku.dk>
cc: ceph-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [ceph-devel] [PATCH 8/9] fs/ceph: Eliminate useless code
In-Reply-To: <Pine.LNX.4.64.1001161659520.28745@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.1001201518230.29039@cobra.newdream.net>
References: <Pine.LNX.4.64.1001161659520.28745@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jan 2010, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> The variable client is initialized twice to the same (side effect-free)
> expression.  Drop one initialization.

Applied to the ceph tree.

Thanks-
sage
