Return-Path: <linux-kernel-owner+w=401wt.eu-S936493AbXGWVHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936493AbXGWVHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936542AbXGWVHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:07:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50252 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936538AbXGWVHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:07:04 -0400
Date: Mon, 23 Jul 2007 14:07:01 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix gfp_t annotations for slub
Message-ID: <20070723140701.69f22b65@schroedinger.engr.sgi.com>
In-Reply-To: <20070720151806.GJ21668@ftp.linux.org.uk>
References: <20070720151806.GJ21668@ftp.linux.org.uk>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 16:18:06 +0100
Al Viro <viro@ftp.linux.org.uk> wrote:

> 	Since we have use like ~SLUB_DMA, we ought to have the type
> set right in both cases.

Acked-by: Christoph Lameter <clameter@sgi.com>
