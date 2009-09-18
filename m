Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbZIRJYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbZIRJYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 05:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZIRJYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 05:24:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43560 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751529AbZIRJYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 05:24:11 -0400
Date: Fri, 18 Sep 2009 10:25:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
 maintenance disaster
Message-ID: <20090918102540.0a683607@lxorguk.ukuu.org.uk>
In-Reply-To: <20090918060320.GD7104@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<20090917125759.GA4045@kroah.com>
	<20090917140548.4e6ee596@lxorguk.ukuu.org.uk>
	<20090917132909.GB4779@kroah.com>
	<20090917164325.38994b47@lxorguk.ukuu.org.uk>
	<20090918060320.GD7104@kroah.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Christoph has already nacked the code and indicated some problems (albeit
> > in his inimitably friendly fashion) so you had at least one review, you
> > just apparently didn't like the answer.
> 
> No, he did not point out any technical problem with the code that I can
> find.  I asked for details, but he's probably on a plane at the moment.

I quote:

"this touches init code to mount stuff inside the namespace fro ma
filesystem driver which is a big no-go"

