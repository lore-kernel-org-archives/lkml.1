Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbXBYVEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbXBYVEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 16:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXBYVEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 16:04:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:54460 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbXBYVEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 16:04:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bExIIw4Ztnem5AaSz0jjzR0+bYyqqKBNQbmVjHPxgOOf9g0TvTaAxmYQcHiMVv9tmiAe0Z5qcBUOq7k8DF18Ju8FLQOSEXNo2oWmXQjdWxWWFHUEXut2HF4PhtJH288zqRaARF910yZQ2u6l5QX3fSJZY3qJG8+F9hYbL4Nw7Rw=
Date: Mon, 26 Feb 2007 00:04:44 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Uwe Bugla <uwe.bugla@gmx.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, bunk@stusta.de,
       linux-kernel@vger.kernel.org
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot be mounted without hanging up the whole system
Message-ID: <20070225210444.GA5589@martell.zuzino.mipt.ru>
References: <20070225182939.154020@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225182939.154020@gmx.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 07:29:39PM +0100, Uwe Bugla wrote:
> "The bug was introduced somewhere at the transition of 2.6.20 towards
> 2.6.20-git14."
> I fortunately had some git9 patch at home and found out that it is sane.

> "I'm afraid that the most proactical
> way of fixing this is to ask you to run a git-bisect to find the
> changeset which introduced the regression."
> Until you aren't even ready to explain me the exact technique of bisecting
> I won't do it and I can't do it.

Do you have something called git installed?
If yes, have you cloned mainline git tree?

