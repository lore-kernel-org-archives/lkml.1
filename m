Return-Path: <linux-kernel-owner+w=401wt.eu-S935768AbXEWRVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935768AbXEWRVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbXEWRVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:21:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:18805 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbXEWRVc (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mTUylvadcYC3nriR81P7Feuy+nK3embwa6ietL8Ua+f1wujJoAL2V6X+geIxOvsrGC7k0ZvWAWFn9q7avBlZaNg8igwTkpJWPg8EJ9p11jcWz1fQNCnjmKEmYNWeu3VYmnmzQtnoJqqOSv6KB/umRAsS2fJS1LhBRNFgmxUgkm8=
Message-ID: <6934efce0705231021x6cc45c61kf253eae185504611@mail.gmail.com>
Date: Wed, 23 May 2007 10:21:31 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: carsteno@de.ibm.com
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
In-Reply-To: <4653F264.1030807@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
	 <4653F264.1030807@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> To me, it looks like this
> work can be modified to use filemap_xip.

How?
