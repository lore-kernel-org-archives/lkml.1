Return-Path: <linux-kernel-owner+w=401wt.eu-S1761759AbYDNQEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761759AbYDNQEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbYDNQEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:04:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37872 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbYDNQEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:04:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=J0s6Nb/9Do812DieP9Xg+p3pUtSwP/1+RvSYF5Y6nQBPFFRocnYTU4/I6GAPi3k+O
	pdPmYq4OkqCGbgXkhE1jQ==
Message-ID: <6599ad830804140904v66fab79at8c12e19db64f6608@mail.gmail.com>
Date: Mon, 14 Apr 2008 09:04:28 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <48036F14.3050409@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48036677.3010807@linux.vnet.ibm.com>
	 <48036F14.3050409@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 7:49 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Balbir Singh wrote:
>
> > If nobody has any specific objection to this patch, can I go ahead and
> request
> > Andrew to include this patch?
> >
>
>  ->owner in struct mm_struct is very useful for revokeat() so
>
>  Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
>

Reviewed-by: Paul Menage <menage@google.com>

I'm still not sure when to use Acked-by versus Reviewed-by - is it
just based on the level of scrutiny/review?

Paul
