Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYJHPLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYJHPLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 11:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYJHPLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 11:11:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753960AbYJHPLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 11:11:37 -0400
Message-ID: <48ECCD68.7020104@linux-foundation.org>
Date: Wed, 08 Oct 2008 10:10:32 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rusty@rustcorp.com.au,
       jeremy@goop.org, ebiederm@xmission.com, travis@sgi.com,
       herbert@gondor.apana.org.au, xemul@openvz.org, penberg@cs.helsinki.fi
Subject: Re: [patch 0/4] Cpu alloc V6: Replace percpu allocator in modules.c
References: <20080929193500.470295078@quilx.com> <20081007163449.0716be54.akpm@linux-foundation.org>
In-Reply-To: <20081007163449.0716be54.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 29 Sep 2008 12:35:00 -0700
> Christoph Lameter <cl@linux-foundation.org> wrote:
> 
>> Just do the bare mininum to establish a per cpu allocator. Later patchsets
>> will gradually build out the functionality.
> 
> I need to drop these - the dynalloc thing (I don't think I even know
> what it does) in Ingo's trees make changes all over the place and
> nothing much applies any more.

Got a tree to rediff agains?


