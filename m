Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbXEPWIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbXEPWIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760377AbXEPWIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:08:47 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:16004 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760059AbXEPWIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:08:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Q+iUe6mQ5VPjpKge8ZzMjZ64b9Ffpvvy1dVfkv8Tyhtkn9pmOYAxmTpTrv/DXWa7PuXJANR1t2ji+ZZZ91OXJeLvt2DEGFClG7VjWdCfT7yPspk8woS8SMaQqKDa43JktDihsIEA6INXitr1hIJjAotLgnE+MNLkzf1brvb+iAc=
Message-ID: <2c0942db0705161508jc53353ev8a2aa8c5f372d982@mail.gmail.com>
Date: Wed, 16 May 2007 15:08:44 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/3] 2.6.22-rc1: known regressions v2
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       "Len Brown" <lenb@kernel.org>
In-Reply-To: <464B6A22.905@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464B6A22.905@googlemail.com>
X-Google-Sender-Auth: dda15be6f3a738d8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> ACPI
>
> Subject    : nx6125 has lost fan control
> References : http://lkml.org/lkml/2007/5/16/249
> Submitter  : Ray Lee <ray-lk@madrabbit.org>
> Status     : Unknown

While it worked in 2.6.21, that was pretty much the only point-release
kernel where it did. In other words, I'm honestly not sure I'd
classify this as a regression given it worked exactly once :-/. So,
I'd suggest pulling this from the list for now unless Len decides
otherwise.

Ray
