Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbYBNPXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbYBNPXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYBNPXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:23:33 -0500
Received: from smtp-out.google.com ([216.239.33.17]:31908 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbYBNPXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:23:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=rOmkUuyX1w7Bry1R1Ycj7D88uoM6oexS3Em5o+VIOPwrcpN3aIpm8TSpax7N/zk4R
	FuKlsNcvpOsFNxawOdb5g==
Message-ID: <6599ad830802140723t2239c432v3610d9a0fd77e862@mail.gmail.com>
Date: Thu, 14 Feb 2008 07:23:21 -0800
From: "Paul Menage" <menage@google.com>
To: "Christoph Hellwig" <hch@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <6599ad830802140722t2e3a2779sa323657dfd6da841@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B283EB.8070209@google.com>
	 <20080214060201.GA17680@infradead.org>
	 <6599ad830802140722t2e3a2779sa323657dfd6da841@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ cc: linux-fsdevel ]

On Thu, Feb 14, 2008 at 7:22 AM, Paul Menage <menage@google.com> wrote:
> On Wed, Feb 13, 2008 at 10:02 PM, Christoph Hellwig <hch@infradead.org> wrote:
>  >
>  >  I think this concept is reasonable, but I don't think MS_BIND_FLAGS
>  >  is a descriptive name for this flag.  MS_EXPLICIT_FLAGS might be better
>  >  but still isn't optimal.
>  >
>
>  MS_BIND_FLAGS_OVERRIDE ?
>
>  Paul
>
