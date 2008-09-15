Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYIOPmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYIOPmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 11:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYIOPmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 11:42:24 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:41278 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbYIOPmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 11:42:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D/jBuVxdk2cOMkbYl+UX35YDF43vqegm7QPLcJSUKra4IYBwqQpuc3t9LNzPy4PR7H
         OIeYRvPwyOSOQyx/87PT8+35v45PuAQssiljvv2sqOIArZ9EVi3JYt6d1uWLb9kF7/7g
         URFzN8jbtrd1m6tlxZVrnaeDQkw8TG62MUjYA=
Message-ID: <6934efce0809150842j475935b2o342db9e2ff1328fb@mail.gmail.com>
Date: Mon, 15 Sep 2008 08:42:21 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Tomas M" <tomas@slax.org>
Subject: Re: advantages of AXFS over squashfs?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48CA386C.609@slax.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48CA386C.609@slax.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I read somewhere that AXFS is going to be a part of Linux kernel 2.6.28
> ( http://www.linuxdevices.com/news/NS6179099416.html?kc=rss )
>
> What are the advantages of AXFS compared to squashfs?

Depends on what you are doing and what features you care about.  You
can read some of the threads starting ~Aug 20th for the details.

> Why not to include squashfs instead?

To be clear, the submission of AXFS has nothing at all to do with
squashfs.  It's not a || it's an && operation.

But yeah, Christoph is right.  2.6.28 is iffy for AXFS anyway.
