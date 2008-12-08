Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYLHLyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYLHLyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757044AbYLHLsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:48:43 -0500
Received: from styx.suse.cz ([82.119.242.94]:56269 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757034AbYLHLsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:48:42 -0500
Date: Mon, 8 Dec 2008 12:48:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Nick Andrew <nick@nick-andrew.net>
cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix incorrect use of loose in event.c
In-Reply-To: <20081205030802.32056.24527.stgit@marcab.local.tull.net>
Message-ID: <alpine.LNX.1.10.0812081248270.21089@jikos.suse.cz>
References: <20081205030802.32056.24527.stgit@marcab.local.tull.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008, Nick Andrew wrote:

> Fix incorrect use of loose in event.c
> 
> It should be 'lose', not 'loose'.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>

Applied to trivial tree, thanks.

-- 
Jiri Kosina
SUSE Labs
