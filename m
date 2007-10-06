Return-Path: <linux-kernel-owner+w=401wt.eu-S1765410AbXJFVeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765410AbXJFVeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 17:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbXJFVeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 17:34:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10773 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbXJFVeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 17:34:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=jzfdaW2LNanuNqillSM7rFUqV9iVChhp2ke7+hH+VRNaj+lRQlCDnAqlVORJG823w
	NNbeMowDycg3uUd9vjGog==
Message-ID: <6599ad830710061434t5fe36b1ai9e99f1c11f8753b6@mail.gmail.com>
Date: Sat, 6 Oct 2007 14:34:00 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>, "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] cpusets - decrustify cpuset mask update code
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071006094749.17518.88048.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071006094749.17518.88048.sendpatchset@jackhammer.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/07, Paul Jackson <pj@sgi.com> wrote:
> From: Paul Jackson <pj@sgi.com>
>
> Decrustify the kernel/cpuset.c 'cpus' and 'mems' updating code.
>
> Other than subtle improvements in the consistency of identifying
> white space at the beginning and end of passed in masks, this
> doesn't make any visible difference in behaviour.  But it's
> one or two hundred kernel text bytes smaller, and easier to
> understand.
>
> Signed-off-by: Paul Jackson <pj@sgi.com>

Reviewed-by: Paul Menage <menage@google.com>

Looks fine to me.

Paul
