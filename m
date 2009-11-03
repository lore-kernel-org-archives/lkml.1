Return-Path: <linux-kernel-owner+w=401wt.eu-S1752300AbZKDABh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbZKDABh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZKDABh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:01:37 -0500
Received: from smtp2.ultrahosting.com ([74.213.174.253]:34811 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752473AbZKDABg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:01:36 -0500
Date: Tue, 3 Nov 2009 13:06:37 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 7/14] cpumask: avoid deprecated function in mm/slab.c
In-Reply-To: <200911031457.39368.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0911031306050.32136@V090114053VZO-1>
References: <200911031457.39368.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009, Rusty Russell wrote
>
> These days we use cpumask_empty() which takes a pointer.

Acked-by: Christoph Lameter <cl@linux-foundation.org>
