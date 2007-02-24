Return-Path: <linux-kernel-owner+w=401wt.eu-S933543AbXBXTt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543AbXBXTt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 14:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933545AbXBXTt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 14:49:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:25691 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933543AbXBXTtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 14:49:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=doDtAfISZNh1GNoCqh0Ak1msok+4kAuiAD75j58tPpKZ1fnUDXz9sdM1nfdX9EMkPjPe52FGObiJWga/kJF4OyrGWgfp9E2XPexCGXYI0bRe44Kzdvgv8qqkKuV9i9fILixmqzgBuwKK5H1ppoUjDl5n3mUo6VokU6znZgPIgLQ=
Message-ID: <2c0942db0702241149g39b6c66dhf08429abeca30c81@mail.gmail.com>
Date: Sat, 24 Feb 2007 11:49:53 -0800
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot be mounted without hanging up the whole system
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bunk@stusta.de, torvalds@linux-foundation.org
In-Reply-To: <20070224192326.258280@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070224175424.176030@gmx.net>
	 <20070224100729.8675b425.akpm@linux-foundation.org>
	 <20070224192326.258280@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> it is definitely NOT my job to repair errors that other responsibility-free people pushed into vanilla mainline without the slightest test effort in some mm-tree for example. Who wasted it must repair it, without the slightest discussion!

You're assuming the author didn't test it. For things like floppy.c,
it's possible it was tested and worked on their system just fine, but
is broken on yours. As you can replicate the problem, you're the
natural person to help narrow down the cause. This is the way all
development works, not just Linux or free software.

Please start by assuming that people mean well and are trying to do
the right thing, and you'll get a lot more productive responses.

> So take action now please!

And please remember that the vast majority of us, just like you, are volunteers.

Ray
