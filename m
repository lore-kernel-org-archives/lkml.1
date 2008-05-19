Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbYESKjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbYESKjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 06:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbYESKjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 06:39:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:11765 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbYESKjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 06:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NZEIl/XqO60gAZhDsmkHr+3VpZBWcF2ZUd+kARsp6WH0NwXufCAQj8xOqgFCAhUCLOuJpE5mYXkK7Xm4G1uHWvwWEfzydHxjJTDStnBZDHT2B1nDNbIAmRtWYy5A2ZZTNXoQZOWdOL9aNV7U8YmseZcFm336ZauYR6NMleL0MA0=
Message-ID: <e85b9d30805190339w7466dc2eqb1920bf2672eb54b@mail.gmail.com>
Date: Mon, 19 May 2008 12:39:07 +0200
From: Matthew <jackdachef@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Cc: fchecconi@gmail.com, "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Aaron Carroll" <aaronc@cse.unsw.edu.au>
In-Reply-To: <e85b9d30805161549o7c8f065do24b6567e2ade0afa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513122021.GP16217@kernel.dk>
	 <20080513180334.GS16217@kernel.dk> <20080513184057.GU16217@kernel.dk>
	 <6278d2220805140105x27292033u6a97dcf13ab54263@mail.gmail.com>
	 <20080514082622.GA16217@kernel.dk>
	 <e85b9d30805140332r3311b2d6r6831d37421ced757@mail.gmail.com>
	 <e85b9d30805140334q69cb5eacued9a719414e73d53@mail.gmail.com>
	 <20080514103956.GD16217@kernel.dk>
	 <e85b9d30805141239g5df9abc6i666b1f621d632b44@mail.gmail.com>
	 <e85b9d30805161549o7c8f065do24b6567e2ade0afa@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just wrote a bug-report as a reminder for this problem:

http://bugzilla.kernel.org/show_bug.cgi?id=10746

I hope it's classified in the right subsystem & has enough information
(2 links to this discussion)

Jens, I just looked a little through lkml while searching for the
above mentioned 2 links and found the following post:
http://lkml.org/lkml/2006/12/7/319 is it anyhow related to this issue
?

Thanks

Mat
