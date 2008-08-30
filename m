Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYH3T3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYH3T3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYH3T3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:29:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:47252 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYH3T3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sAJ7RVI5XJcSpYjylrNoTitREKi0CqCxdsEIjLlItqz4zBvbM3cF8DsF8TGOiRvIyV
         TCnlbJz04KRGXxXq3nvoiRHed/SXqGK75rpZpoIou/oR0ul6BrJBlaoFsVH3JySDQwU2
         N4ZEjzf38ILSJN+AJWjqaQuwim9nKkmxDESD8=
Message-ID: <86802c440808301229u45df4cc3m298a479f5ec4ad1@mail.gmail.com>
Date: Sat, 30 Aug 2008 12:29:31 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <200808302129.24584.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808301150150.3290@nehalem.linux-foundation.org>
	 <200808302129.24584.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 12:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

>
> There are some at:
> http://www.amd.com/us-en/Processors/TechnicalResources/0,,30_182_739_15137,00.html
>
> Well, that's 690/SB600 only and I'm not sure how useful this is.
>
that is for HW guys.

YH
