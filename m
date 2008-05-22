Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYEVQie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYEVQie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbYEVQiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:38:22 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:27957 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbYEVQiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z6k+iPh6KDdUGMq06KvNMfGYo+EmBzbzIvLLBNguu6qePwYB7Rh49+9qhdqq+W2Afa29WUpggp145S26CcvI8VmGQTLqEJ7dn9ORPCYApif6MGU8j3Cy43MYE4FyZdQSjPBqZUTj2Ae73OPyVD2GiyY8RRp9U9mVaN8H69OPBDw=
Message-ID: <e2e108260805220938w718d39ddh633c48a6373fd682@mail.gmail.com>
Date: Thu, 22 May 2008 18:38:18 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Number of bugs - statistics
Cc: "Adrian Bunk" <bunk@kernel.org>, "Arjan van de Ven" <arjan@infradead.org>,
       "Bosko Radivojevic" <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <48359DE1.8050600@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d6c8ef150805220528w6c4911bfq2be92eaa487a0f3@mail.gmail.com>
	 <20080522144114.GC27301@cs181133002.pp.htv.fi>
	 <20080522075135.4933161c@infradead.org>
	 <20080522155425.GA2727@cs181133002.pp.htv.fi>
	 <48359DE1.8050600@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 2:28 PM, Bosko Radivojevic
<bosko.radivojevic@gmail.com> wrote:
> Is there any kind of analysis of number of (reported or resolved) bugs
> through time in Linux kernel floating around? I'm trying to convince
> my colleagues that newer kernel version does not mean more bugs than
> the previous 'well tested' ones.

The following summary of a speech by Andrew Morton contains good
arguments as why you should use a recent kernel:
http://lwn.net/Articles/278647/

Bart.
