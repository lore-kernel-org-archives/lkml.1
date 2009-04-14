Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbZDNJVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbZDNJVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZDNJUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:20:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57457 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbZDNJUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:20:52 -0400
Subject: Re: [PATCH -tip] x86: page_types.h unification of declarations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1239693869.3033.31.camel@ht.satnam>
References: <1239693869.3033.31.camel@ht.satnam>
Date: Tue, 14 Apr 2009 12:20:49 +0300
Message-Id: <1239700849.24789.5.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 12:54 +0530, Jaswinder Singh Rajput wrote:
> Impact: unification of declarations, cleanup
> 
> Unification of declarations:
>  moved init_memory_mapping, initmem_init and free_initmem from
> page_XX_types.h to page_types.h
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Looks good to me!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

