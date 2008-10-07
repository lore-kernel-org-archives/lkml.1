Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbYJGXf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbYJGXf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbYJGXfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:35:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741AbYJGXfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:35:39 -0400
Date: Tue, 7 Oct 2008 16:34:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rusty@rustcorp.com.au,
       jeremy@goop.org, ebiederm@xmission.com, travis@sgi.com,
       herbert@gondor.apana.org.au, xemul@openvz.org, penberg@cs.helsinki.fi
Subject: Re: [patch 0/4] Cpu alloc V6: Replace percpu allocator in modules.c
Message-Id: <20081007163449.0716be54.akpm@linux-foundation.org>
In-Reply-To: <20080929193500.470295078@quilx.com>
References: <20080929193500.470295078@quilx.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 12:35:00 -0700
Christoph Lameter <cl@linux-foundation.org> wrote:

> Just do the bare mininum to establish a per cpu allocator. Later patchsets
> will gradually build out the functionality.

I need to drop these - the dynalloc thing (I don't think I even know
what it does) in Ingo's trees make changes all over the place and
nothing much applies any more.

