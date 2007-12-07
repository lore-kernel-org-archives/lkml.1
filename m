Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbXLGTQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbXLGTQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 14:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbXLGTQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 14:16:38 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:32489 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbXLGTQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 14:16:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DFpgWz4AEFTAytaGJKY4p3ENgWjvRb/F3SpZhCvnZ0aL9iANAucuJXh7bwUkVZOOuCedNeRcsnxLYtjufnua1J46hZEn+50o3d0MRBRXeEzKTznQNsGMAIh7b2SqxBe9xKNb1lwaGRrl8NK+AzWaQcXYHjHSpQ11r2+alvRll5E=
Message-ID: <fa4052ef0712071116x2b727faau190ec14e4b2a2d47@mail.gmail.com>
Date: Fri, 7 Dec 2007 14:16:36 -0500
From: Shane <gnome42@gmail.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <fa4052ef0712071055r2fe33f2ep34fed2537970c8ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	 <20071207040219.e231cbc7.akpm@linux-foundation.org>
	 <fa4052ef0712071014l524951e2we4705d84c5005cf3@mail.gmail.com>
	 <1197053179.7532.23.camel@heimdal.trondhjem.org>
	 <fa4052ef0712071055r2fe33f2ep34fed2537970c8ef@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007 1:55 PM, Shane <gnome42@gmail.com> wrote:
> On Dec 7, 2007 1:46 PM, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> ...
> > This problem has already been reported. The fix (which I'm planning on
> > sending to Linus soon) is appended.
>
> Thanks Trond. Sorry for the duplicate report, I did actually do some
> searching...
>
> I will confirm the fix.

Confirmed working in rc4-git5.  I'll deploy this kernel in a few more
spots and check for other regressions.

Thanks again,

Shane
