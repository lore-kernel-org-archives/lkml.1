Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbXERNG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbXERNG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 09:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbXERNGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 09:06:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:9026 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbXERNGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 09:06:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V2ExhnrxrfJzG2N7aSQ/uN9XCtuXMRzN0KQDJ6arFd157hXNALlQQhedJ+Na9shAq2Os2vmD0WxcsxgWbFAXi9nOIPvDLGnIZ78avVtsCdEniMP7qSPKLQvN01XmSmxzc6N16CdPEzcdwDhkpfYnHuOF8aChuNF2QbWbaNZpXf8=
Message-ID: <a781481a0705180606i28b2f9a8q89b3b618f40d4122@mail.gmail.com>
Date: Fri, 18 May 2007 18:36:48 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: Asynchronous scsi scanning
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070518111911.GP10562@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com>
	 <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com>
	 <20070517182414.GA12170@infradead.org>
	 <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com>
	 <20070517185115.GA13207@infradead.org>
	 <a781481a0705171204o5b25fafdm36d5970acf9119cd@mail.gmail.com>
	 <20070517193953.GM10562@parisc-linux.org>
	 <20070517194326.GC30571@kvack.org>
	 <a781481a0705172041q6bc87f04v7a60eb62ad26d6@mail.gmail.com>
	 <20070518111911.GP10562@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/07, Matthew Wilcox <matthew@wil.cx> wrote:
> On Fri, May 18, 2007 at 09:11:58AM +0530, Satyam Sharma wrote:
> > It's also somewhat a matter of *taste* (and hence subjective), if you
> > _still_ don't get it, Matthew, then there's no point continuing this thread
> > and trying to convince you ad infinitum.
>
> Right.  It's a matter of taste.  What makes you think you have taste?

Well, my stand uptil now has been to consider as many options as
possible. I have certainly not married myself to just one particular way
of doing this -- but I bet that the one way that I do _dislike_, the dummy
module one, would not be found tasteful / best by most people around
(yourself included, as you say).

> I don't think that the module solution is perfect.  But abusing the
> module parameters is a worse idea.  sysfs just isn't a good fit for this,
> according to my taste.

The whole point is to at least _consider_ other alternatives. And I've
found your attitude so far to have been extremely blocking / difficult.
