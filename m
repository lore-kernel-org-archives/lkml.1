Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbXGTC71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbXGTC71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 22:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXGTC7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 22:59:18 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:48483 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbXGTC7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 22:59:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EBW8CyzH8IGfa+DIOBa43vQgg3Sdp1RC9DqXszSRRSfXXwZ2vIYPu+4KUOFhsFdVpdLSATAC5ptlL3wU/mpMwq1LXhBy7AvfFAH9IbImBqJImKjZnvMPkIPQa/SAM2VaM5wW6srDvnYFlSryzJgqM99sZJ/zD1hsT1PMZEWy8Gk=
Message-ID: <e9c3a7c20707191959s394522e1ia4e180fc3d57b331@mail.gmail.com>
Date: Thu, 19 Jul 2007 19:59:16 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] async_tx: fix kmap_atomic usage in async_memcpy
Cc: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru
In-Reply-To: <20070719183202.f7045ede.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720011252.6443.34295.stgit@dwillia2-linux.ch.intel.com>
	 <20070719183202.f7045ede.akpm@linux-foundation.org>
X-Google-Sender-Auth: 67c5e70fcd99cdfc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> Neato.
>
> You (or at least, Shannon) run a git tree.  I always get confused when
> git-tree-owners send me patches, because I expect them to put the
> patches into their git trees.
>
> So if you, a git-tree-owner, wish me to merge-test-and-forward a patch,
> please explicitly tell me.
> -

Please merge-test-and-forward this one, I will have an 'async_tx' git
topic branch setup for these things shortly.

Thanks,
Dan
