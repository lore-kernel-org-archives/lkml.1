Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbZEKAxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbZEKAxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 20:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZEKAxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 20:53:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbZEKAxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 20:53:39 -0400
Date: Sun, 10 May 2009 17:48:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
       randy.dunlap@oracle.com, torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: RFC: MAINTAINER email address style?
Message-Id: <20090510174818.c5ccaa36.akpm@linux-foundation.org>
In-Reply-To: <20090510205326.GA22578@uranus.ravnborg.org>
References: <20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	<1240003652.31116.44.camel@localhost>
	<20090407081312.GH1408@ucw.cz>
	<1240415689.21848.19.camel@localhost>
	<20090422185916.GA3864@uranus.ravnborg.org>
	<20090422120510.cc17e470.akpm@linux-foundation.org>
	<1240430185.21848.103.camel@localhost>
	<20090422203005.GA467@elf.ucw.cz>
	<1240557233.6735.240.camel@localhost>
	<1241987200.3877.9.camel@Joe-AcerAspire>
	<20090510205326.GA22578@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 May 2009 22:53:26 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:

> > Should names and email addresses in MAINTAINERS be integrated?
> > Should it stay as-is or be changed to:
> > 
> > M: name <email>
> > M: name2 <email2>
> 
> I strongly prefer this style. It fits the way I do
> copy'n'paste of selected email addresses.
> 
> If I want to add Rafael in a Cc: line I have to
> anually add "" to surround his name due to the "J." and I
> have to manually add <>.

Yup, I do that operation many times per day and it's a pita.  I'd much
prefer something in MAINTAINERS which I can just copy-n-paste into a 
changelog and into an email client.

I go to my email client address book first, because it presents the
info in the correct form, and has tab-completion.  But sometimes my
address book has people's non-preferred or old addresses in it, and not
everyone has an address book as voluminous as mine.


