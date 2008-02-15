Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYBOUOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYBOUOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760892AbYBOUNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:13:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:37040 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760459AbYBOUNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:13:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Wy49KVegqubdFVpHEDemfaXEYlH2G6MmQ8OUxf7QrM9WgfvrW0WOVk1I/poIoqmVNJ7yh0hbOcn6puXsbbOnfo0C7CVcqGu5XFh/zAgj8syc5HeD4G9k73PuqIC1Uoj7F+JTncDWE/+iVN70HPiq00SUCqsPmPGNivwjDXrl0CI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: 2.6.24-mm1 bugs
Date: Fri, 15 Feb 2008 21:27:29 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: jdike@addtoit.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu> <20080215184741.GB8810@c2.user-mode-linux.org> <E1JQ6bM-0005z4-Ac@pomaz-ex.szeredi.hu>
In-Reply-To: <E1JQ6bM-0005z4-Ac@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802152127.30413.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2008, Miklos Szeredi wrote:
> > >  - UML doesn't boot: guest is 2.6.24-mm1 also, haven't tried any
> > >    other.  Same guest boots fine on 2.6.24 host.
> > 
> > What does it do?
> 
> See below.
> 
> > 
> > Any chance you can bisect it?
> 
> It would be a bit painful, because this is the only machine I can use.
> I much prefer bisecting UML kernels :)

Is it possible to bisect uml kernels inside qemu? :)

Thanks,
Bart
