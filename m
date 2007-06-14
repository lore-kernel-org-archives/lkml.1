Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbXFNT6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbXFNT6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbXFNT6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:58:23 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51875 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750944AbXFNT6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:58:22 -0400
Date: Thu, 14 Jun 2007 12:58:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 01/14] Define functions for page cache handling
In-Reply-To: <20070614195646.GB2258@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0706141257390.964@schroedinger.engr.sgi.com>
References: <20070614193839.878721298@sgi.com> <20070614194052.663061482@sgi.com>
 <20070614195646.GB2258@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Sam Ravnborg wrote:

> We need access to PAGE_SIZE in vmlinux.lds.h.
> What is your plan with that usage?

This is about PAGE_CACHE_xxx. No changes to PAGE__SIZE are planned.

