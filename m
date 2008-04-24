Return-Path: <linux-kernel-owner+w=401wt.eu-S1763453AbYDXUWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763453AbYDXUWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762048AbYDXUWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:22:02 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51381 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762028AbYDXUWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:22:01 -0400
Date: Thu, 24 Apr 2008 21:21:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RxRPC: Fix a regression in the RXKAD security module
Message-ID: <20080424202155.GC5882@ZenIV.linux.org.uk>
References: <20080424193856.14737.16718.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424193856.14737.16718.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 08:38:56PM +0100, David Howells wrote:
> Fix a regression in the RXKAD security module introduced in:
> 
> 	commit 91e916cffec7c0153c5cbaa447151862a7a9a047
> 	Author: Al Viro <viro@ftp.linux.org.uk>
> 	Date:   Sat Mar 29 03:08:38 2008 +0000
> 
> 	net/rxrpc trivial annotations
> 
> A variable was declared as a 16-bit type rather than a 32-bit type.

ACK with apologies
