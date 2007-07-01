Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbXGAFbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbXGAFbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 01:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXGAFbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 01:31:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:22705 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbXGAFbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 01:31:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RbGxW+UTt/gr7lni/emDX2NOSgx7WnXkX2iovMWK9r/CrApCytJrOL7plwApuNLd1LxeUmp7rKkaDyTtftnX653o3RrVplWYmAHxb108il2AUVkWeBbifUGoHWUBcTGyvpHaxqXhCd1dDCOc5+qsiL6MXPr+xziFeCRzmq/5KQc=
Message-ID: <a781481a0706302231g70bd82c9m9d91abae411233ee@mail.gmail.com>
Date: Sun, 1 Jul 2007 11:01:45 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: 2.6.22-rc6-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070630211017.GA26234@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	 <6150.1183128630@turing-police.cc.vt.edu>
	 <20070629140130.59d58c44.akpm@linux-foundation.org>
	 <15437.1183177066@turing-police.cc.vt.edu>
	 <20070629221510.95c4c8e1.akpm@linux-foundation.org>
	 <20070630211017.GA26234@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/1/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> [...]
> I am heading for vacation for 20 days without Internet (real vacation :-))

I hope I'm not late in catching you here ...

> By the way - kbuild.git is lacking behind on patches.
> I have several queded from other peopel and have more in the works myself.

... is http://lkml.org/lkml/2007/6/23/116/ one of those queued up too?

Note that that patch is also:
Tested-by: Adrian McMenamin <adrian@newgolddream.dyndns.info>

As you can see from:
http://readlist.com/lists/vger.kernel.org/linux-kernel/72/361641.html

[ I think I'll utilize the next few days going through my patches-to-do
list and resurrecting old patches-that-fell-into-lkml-blackhole ... ]

Satyam
