Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbYKZLKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbYKZLKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYKZLKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:10:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45655 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYKZLKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:10:03 -0500
Date: Wed, 26 Nov 2008 12:20:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 06/24] perfmon: generic x86 definitions (x86)
Message-ID: <20081126112028.GR6703@one.firstfloor.org>
References: <492d0be4.09b6660a.1678.ffffa78b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492d0be4.09b6660a.1678.ffffa78b@mx.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /*
> + * Perfmon PMU interrupt vector
> + */
> +#define LOCAL_PERFMON_VECTOR	0xee

There's a new dynamic vector allocator that can be used instead.

-Andi

