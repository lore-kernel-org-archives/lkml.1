Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbXJ2CyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbXJ2CyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXJ2Cx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:53:57 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43396 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752149AbXJ2Cx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:53:57 -0400
Date: Sun, 28 Oct 2007 19:53:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: nr_slabs is an atomic_long_t
In-Reply-To: <20071029131540.13932677.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0710281953460.28636@schroedinger.engr.sgi.com>
References: <20071029131540.13932677.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Stephen Rothwell wrote:

> so shouldn't be passed to atomic_read.

That was already fixed AFAICT.
