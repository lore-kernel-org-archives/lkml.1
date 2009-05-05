Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbZEEIXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbZEEIXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757472AbZEEIXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:23:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbZEEIW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:22:58 -0400
Date: Tue, 5 May 2009 10:22:57 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLQB: Use _RET_IP_ instead of __builtin_return_address(0)
Message-ID: <20090505082257.GD30220@wotan.suse.de>
References: <Pine.LNX.4.64.0905031513410.32397@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905031513410.32397@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 03:14:32PM +0300, Pekka Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch changes SLQB to use the shorter _RET_IP_ form for consistency
> with SLUB and to prepare SQLB for eventual kmemtrace hooks.
> 
> Cc: Nick Piggin <npiggin@suse.de>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Ack, thanks.

