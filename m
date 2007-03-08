Return-Path: <linux-kernel-owner+w=401wt.eu-S933242AbXCHUAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbXCHUAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933251AbXCHUAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:00:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:35909 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256AbXCHUAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:00:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=S5iq5rxhhR/YtL2r826zoYX/FfPlVLc2iDXtZsE5jeDrWQBnEvsb5qfh224af3oxFtfa+hvFkt9ruXnpNM0f7ALedfLZ0g+1ldfZ95gxnK/7vOJalgPhVp5xMwVRR01vLJl1J5Shutt3JfzZ2pc1+B8YZ8T7/9sFimpffPw+mAM=
Message-ID: <b6c5339f0703081200ncf1ca92s775c20e8a9b4825c@mail.gmail.com>
Date: Thu, 8 Mar 2007 15:00:44 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [patch] epoll use a single inode ...
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Avi Kivity" <avi@argo.co.il>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>
In-Reply-To: <200703081211.20662.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED1A3C.6030707@argo.co.il>
	 <200703081042.21454.dada1@cosmosbay.com>
	 <20070308102105.GA21119@infradead.org>
	 <200703081211.20662.dada1@cosmosbay.com>
X-Google-Sender-Auth: 2e97b6f70c7ff406
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +       its done only when the path is needed.). Real filesystems probably

> +       dont want to use it, because their dentries are present in global

Pedantry: it's and don't?

-Bob
