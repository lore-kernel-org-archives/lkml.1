Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbXEUQrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbXEUQrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbXEUQrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:47:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35266 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755100AbXEUQrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:47:31 -0400
Date: Mon, 21 May 2007 09:47:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Remove the deprecated "kmem_cache_t" typedef from slab.h.
In-Reply-To: <Pine.LNX.4.64.0705210604030.17699@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705210947110.25871@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705210604030.17699@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Robert P. J. Day wrote:

> 
> Given that there is no remaining usage of the deprecated kmem_cache_t
> typedef anywhere in the tree, remove that typedef.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

Acked-by: Christoph Lameter <clameter@sgi.com>
