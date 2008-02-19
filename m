Return-Path: <linux-kernel-owner+w=401wt.eu-S1762025AbYBSUrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762025AbYBSUrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761460AbYBSUrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:47:32 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8143 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761433AbYBSUra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:47:30 -0500
Date: Tue, 19 Feb 2008 21:47:25 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix kernel-docbook parameters and files
Message-ID: <20080219204725.GM23197@kernel.dk>
References: <20080218130445.f5f5a205.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218130445.f5f5a205.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18 2008, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> kernel-doc for block/:
> - add missing parameters
> - fix one function's parameter list (remove blank line)
> - add 2 source files to docbook for non-exported kernel-doc functions

Care to rediff and resend, it doesn't apply cleanly anymore?

-- 
Jens Axboe

