Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbZJERun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbZJERun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 13:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZJERum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 13:50:42 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:34614 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbZJERul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 13:50:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rqAy0m092mSmMdyO9GQ8duS8HCxpomU7nUZZQlC8kGNPolBsF3DGBOVSRH4OWjPiwx
         daKLaiAgxpyqsaYzs6svGRsVixMS5CCjjEHlHEbTEb8sJlrup9twe2gEK5cgBmCjvUNK
         6aj7amGwqMADrDPH14Zmszyt+b3/2Sm+/SXiE=
Subject: Re: [PATCH] fs: added KERNEL-DEBUG flag to printk statments
From: Pete <greg.petr@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>, Joe Perches <joe@perches.com>
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091005170903.GA9791@parisc-linux.org>
References: <1254753799.5279.37.camel@linux-k65f.site>
	 <1254756285.5279.39.camel@linux-k65f.site>
	 <20091005170903.GA9791@parisc-linux.org>
Content-Type: text/plain
Date: Mon, 05 Oct 2009 23:19:12 +0530
Message-Id: <1254764952.5279.60.camel@linux-k65f.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Pay special attention to getting DEBUG set in the right place, and
> _at least_ compile-test your code, with and without DEBUG enabled.
> You should really run your code (again, with and without DEBUG enabled)
> and check that it does the right thing.

ok - Thanks will redo, test and send a more generalized version of the
patch which modifies the macro instead.
-Greg

