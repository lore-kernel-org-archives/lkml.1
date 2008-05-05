Return-Path: <linux-kernel-owner+w=401wt.eu-S1761950AbYEEUZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761950AbYEEUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759821AbYEEUZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:25:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbYEEUZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:25:46 -0400
Date: Mon, 5 May 2008 16:25:23 -0400
From: Rik van Riel <riel@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] make mm/rmap.c:anon_vma_cachep static
Message-ID: <20080505162523.4023d50e@cuia.bos.redhat.com>
In-Reply-To: <20080505182712.GI17139@cs181133002.pp.htv.fi>
References: <20080505182712.GI17139@cs181133002.pp.htv.fi>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 21:27:12 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch makes the needlessly global anon_vma_cachep static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All Rights Reversed
