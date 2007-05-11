Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbXEKLrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbXEKLrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 07:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbXEKLrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 07:47:04 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:48749 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbXEKLrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 07:47:03 -0400
Date: Fri, 11 May 2007 07:42:38 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Rene Herman <rene.herman@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
       bunk@stusta.de, randy.dunlap@oracle.com, akpm@linux-foundation.org,
       rpjday@mindspring.com, marcel@holtmann.org, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module_author: don't advice putting in an email
 address
In-Reply-To: <20070511114605.4c2698ec@the-village.bc.nu>
Message-ID: <alpine.DEB.0.98.0705110740420.12363@sigma.j-a-k-j.com>
References: <4643BDF2.9030105@gmail.com>
 <20070511114605.4c2698ec@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The email address is the problem I was trying to fix; with multiple current 
> > and non-current authors and maintainers who might not even be authors the 
> > address(es) available from the tag confuse the issue of whom to contact. 
> > It's moreover also information that easily outdated.
> > 
> > A bit more than half of the tags in the tree don't include an email address 
> > already and I'll submit patches removing more...
> 
> Please don't do this
> 
> NACK this change.
> 
> Whether someone puts their email address into the entry is their own
> business. We do not need a style police for module author entries.
> 
> At most you might want to put
> 
> 	"If you include an email address then please use an address that
> 	 you expect to keep for the long term, and if you change address
> 	 please remember to update or remove the entry"
> 
> > A bit more than half of the tags in the tree don't include an email 
> > address already and I'll submit patches removing more...
> 
> And I'll NAK every one which hasn't been signed off by the email address
> listed OR the address bounces. In which case removing it is good.

Can't we just subtitle it somehow? Add tags: " (current maintainer)",
" (original author, inactive)", " (bug and defect reports)", or whatever 
you like after the names.
