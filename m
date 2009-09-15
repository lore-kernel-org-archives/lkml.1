Return-Path: <linux-kernel-owner+w=401wt.eu-S1758453AbZIOTNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453AbZIOTNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758394AbZIOTNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:13:41 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:39400 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758384AbZIOTNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:13:41 -0400
Date: Tue, 15 Sep 2009 15:11:19 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Tejun Heo <tj@kernel.org>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] percpu for v2.6.32
In-Reply-To: <4AAF411C.2040501@kernel.org>
Message-ID: <alpine.DEB.1.10.0909151510010.3340@V090114053VZO-1>
References: <4AAF411C.2040501@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009, Tejun Heo wrote:

> * All arches except for ia64 have been converted to use the new
>   allocator.

Any plans for this? The percpu operations patchset
requires the new allocator to work on all platforms and I am wondering
when I should repost the set.

