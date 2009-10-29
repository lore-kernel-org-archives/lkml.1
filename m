Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZJ2Osu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZJ2Osu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZJ2Oss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:48:48 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:57275 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754998AbZJ2Osr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:48:47 -0400
Date: Thu, 29 Oct 2009 14:44:43 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Tejun Heo <tj@kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>,
       "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH percpu#for-next] ia64: add sparse annotation to
 __ia64_per_cpu_var()
In-Reply-To: <4AE9A0B3.4010305@kernel.org>
Message-ID: <alpine.DEB.1.10.0910291444240.18197@V090114053VZO-1>
References: <4AE9A0B3.4010305@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009, Tejun Heo wrote:

> ia64 has its own optimized percpu accessor - __ia64_per_cpu_var().
> Add percpu sparse annotations to it.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
