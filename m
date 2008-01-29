Return-Path: <linux-kernel-owner+w=401wt.eu-S1760523AbYA2Rlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523AbYA2Rlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYA2Rlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:41:44 -0500
Received: from ns2.suse.de ([195.135.220.15]:58088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbYA2Rln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:41:43 -0500
Subject: Re: [PATCH] [RFC] block/elevator: change nr_requests handling
From: Nikanth Karthikesan <knikanth@suse.de>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, nickpiggin@yahoo.com.au
In-Reply-To: <1201627774.14644.5.camel@nikanth-laptop.blr.novell.com>
References: <1201627774.14644.5.camel@nikanth-laptop.blr.novell.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 23:17:04 +0530
Message-Id: <1201628824.16911.0.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-29 at 22:59 +0530, Nikanth Karthikesan wrote:

> Check for nr_requests only when io schedulers dispatch
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 

Jens,

The patch is against 2.6.24. Before the block/ll_rw_blk.c splitup.

Thanks
Nikanth

