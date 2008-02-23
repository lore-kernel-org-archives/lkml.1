Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbYBWBgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbYBWBgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 20:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYBWBgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 20:36:13 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:45516 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbYBWBgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 20:36:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a4GkOGO6Gi79eEWqEt6kWUxgdIi77KZFw8e+XiU/rcXmfopntIJ4HGWDJ0bjf96+6z8ZT4bRPsV+iJbsrro78MiqJZw8mype9ZXOfWTPd9sRihig7v9jrSViQE4dO4bz7BIcliQAlEFsP4IBZ2d87lUc5AGohP2FRsKwUT7zmDQ=
Message-ID: <998d0e4a0802221736q4e4c3a28l101522912f7d3caf@mail.gmail.com>
Date: Sat, 23 Feb 2008 02:36:10 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: "Chase Venters" <chase.venters@clientec.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about your git habits
In-Reply-To: <200802221837.37680.chase.venters@clientec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802221837.37680.chase.venters@clientec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/23, Chase Venters <chase.venters@clientec.com> wrote:
>
> ... blablabla
>
>  My question is: If you're working on multiple things at once, do you tend to
>  clone the entire repository repeatedly into a series of separate working
>  directories and do your work there, then pull that work (possibly comprising
>  a series of "temporary" commits) back into a separate local master
>  respository with --squash, either into "master" or into a branch containing
>  the new feature?
>
> ... blablabla
>
>  I'm using git to manage my project and I'm trying to determine the most
>  optimal workflow I can. I figure that I'm going to have an "official" master
>  repository for the project, and I want to keep the revision history clean in
>  that repository (ie, no messy intermediate commits that don't compile or only
>  implement a feature half way).

I recomend you to use these complementary tools

   1. google: gitk screenshots  ( e.g. http://lwn.net/Articles/140350/ )

   2. google: "git-gui" screenshots
         ( e.g. http://www.spearce.org/2007/01/git-gui-screenshots.html )

   3. google: gitweb color meld

   ;)
