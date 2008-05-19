Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbYESWKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbYESWKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765225AbYESWG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:06:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54422 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765207AbYESWG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:06:27 -0400
Date: Mon, 19 May 2008 22:49:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] drivers/char/rio/: remove VCS tags
Message-ID: <20080519224915.22811d1f@core>
In-Reply-To: <20080519215348.GG17716@cs181133002.pp.htv.fi>
References: <20080519215348.GG17716@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 00:53:48 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch removes ancient VCS tags (either protected
> by #ifdef SCCS_LABELS or commented out).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Alan Cox <alan@redhat.com>

Let me take this one via my tty patches however.

Alan
