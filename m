Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYI3W24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYI3W24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYI3W2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:28:48 -0400
Received: from ozlabs.org ([203.10.76.45]:36629 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbYI3W2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:28:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch 4/4] cpu alloc: Use cpu allocator instead of the builtin modules per cpu allocator
Date: Wed, 1 Oct 2008 08:28:43 +1000
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org,
       penberg@cs.helsinki.fi
References: <20080929193500.470295078@quilx.com> <20080929193516.500912533@quilx.com>
In-Reply-To: <20080929193516.500912533@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810010828.44521.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2008 05:35:04 Christoph Lameter wrote:
> Remove the builtin per cpu allocator from modules.c and use cpu_alloc
> instead.
>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
