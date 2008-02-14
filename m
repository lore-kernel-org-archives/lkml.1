Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbYBNPWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbYBNPWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYBNPWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:22:24 -0500
Received: from smtp-out.google.com ([216.239.45.13]:32883 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbYBNPWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:22:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=QdBcktHM7rfue6DPND4KzC2JmKM67nkSK1pKc4bbknrDPl07EMVgvxQesnQX12u/T
	xcremqHWOs8p5IeuPdlLA==
Message-ID: <6599ad830802140722t2e3a2779sa323657dfd6da841@mail.gmail.com>
Date: Thu, 14 Feb 2008 07:22:18 -0800
From: "Paul Menage" <menage@google.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080214060201.GA17680@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B283EB.8070209@google.com>
	 <20080214060201.GA17680@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 10:02 PM, Christoph Hellwig <hch@infradead.org> wrote:
>
>  I think this concept is reasonable, but I don't think MS_BIND_FLAGS
>  is a descriptive name for this flag.  MS_EXPLICIT_FLAGS might be better
>  but still isn't optimal.
>

MS_BIND_FLAGS_OVERRIDE ?

Paul
