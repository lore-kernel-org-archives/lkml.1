Return-Path: <linux-kernel-owner+w=401wt.eu-S965052AbXC1RgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbXC1RgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965069AbXC1RgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:36:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51835 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965075AbXC1RgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:36:04 -0400
Subject: Re: 2.6.21-rc5-mm2
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070326211627.c681af3b.akpm@linux-foundation.org>
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 10:36:09 -0800
Message-Id: <1175106969.17658.9.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 21:16 -0800, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/
> 
> 
> - This is the same as 2.6.12-rc5-mm1, except the staircase deadline CPU
>   scheduler has been added.

Booted fine on my x86-64 and ppc64 machines.
Both failed to boot 2.6.21-rc4-mm1.

Thanks,
Badari

