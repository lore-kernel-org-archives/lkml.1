Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYGPHSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYGPHSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 03:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYGPHSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 03:18:14 -0400
Received: from smtp-out.google.com ([216.239.33.17]:26470 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbYGPHSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 03:18:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=SZPMJdaSq3zla2FzneCKSNg7NukyXCZ4LRECNlsilt/L/ZO/VENxUoFHHG+8sNI+i
	yZlhnV6ALn0QpcFjiT0Cg==
Message-ID: <6599ad830807160017p70943200wb74504d8fa4dca9b@mail.gmail.com>
Date: Wed, 16 Jul 2008 00:17:58 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] cpuset: code-cleanup for started_after
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Paul Jackson" <pj@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <487D6E4D.6040704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <487D6E4D.6040704@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 8:43 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> cgroup(cgroup_scan_tasks) will initialize heap->gt for us.
> this patch removes started_after() and its helper-function.
>
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Looks good, thanks.

Paul
