Return-Path: <linux-kernel-owner+w=401wt.eu-S934875AbXFFQJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934875AbXFFQJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbXFFQJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:09:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:47704 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934908AbXFFQJe (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:09:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jPg+MLKECI0K4m4KwP43s7ohBSAm4Wh/1T7ZkTdMRg9/8D0wuhkbE5WNxH9bnvT1FDVmJhJPbNkbKnmlXYA3kbcWt8dbUonXqsnv+TUxbM1V6d5eEyajS4OUdnczyU7giXX78qzUIPcc0cpyeEgGRho24UR3yKbwqAv4SYFoj08=
Message-ID: <6934efce0706060909t7fba31e7sdfee7985e8aa3b4f@mail.gmail.com>
Date: Wed, 6 Jun 2007 09:09:33 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Richard Griffiths" <richard.griffiths@windriver.com>,
       "Jared Hulbert" <jaredeh@gmail.com>, carsteno@de.ibm.com,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
In-Reply-To: <20070606155021.GA19503@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au>
	 <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com>
	 <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
	 <20070606113351.GA11701@infradead.org>
	 <1181143064.4194.4.camel@localhost.localdomain>
	 <20070606155021.GA19503@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jun 06, 2007 at 08:17:43AM -0700, Richard Griffiths wrote:
> > Too late :) The XIP cramfs patch is widely used in the embedded Linux
> > community and has been used for years. It fulfills a need for a small
> > XIP Flash file system. Hence our interest in getting it or some
> > variation into the mainline kernel.
>
> That's not a reason to put it in as-is.  Maybe you should have showed
> up here before making the wrong decision to hack this into cramfs.
>

Please read the entire thread before passing judgements like this.
The hacks evolved over the last 8 years, and are really handy.  We're
just trying to figure the best way to share them..
