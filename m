Return-Path: <linux-kernel-owner+w=401wt.eu-S1031613AbXEAJRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031613AbXEAJRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031618AbXEAJRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:17:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:17325 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031613AbXEAJRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:17:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QYjeX+N9ghCprWU+I5S17cbcJzKxNwAFF55WxTsPOnb5m5CwGh1nrSYohIpm2GpePni/lGBPvOfmsN+AOWHJqN/x8HgltlhQa46utdLBK8PUz/ABkbKNpllEcszd0cMPu7JyC+Euh9MYihMgO/Z876+dQIvP015RHooHP1VeXz4=
Message-ID: <84144f020705010217j738e461ey6b09fd738574fb70@mail.gmail.com>
Date: Tue, 1 May 2007 12:17:28 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22 -mm merge plans
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hch@lst.de,
       npiggin@suse.de, a.p.zijlstra@chello.nl
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
X-Google-Sender-Auth: bbc87a7fdabdc6fc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>  revoke-special-mmap-handling.patch

[snip]

> Hold.  This is tricky stuff and I don't think we've seen sufficient
> reviewing, testing and acking yet?

Agreed. While Peter and Nick have done some review of the patches, I
would really like VFS maintainers to review them before merge.
Christoph, have you had the chance to take a look at it?
