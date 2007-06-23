Return-Path: <linux-kernel-owner+w=401wt.eu-S1761209AbXFWQyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209AbXFWQyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761342AbXFWQyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:54:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:64607 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760987AbXFWQyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sD5SpH9CcA4ugS1gKXi95c3C01akg4O65oMk9dhwt2zf3cCJshOIehrZBRY2urlhaVPr++7L1gRpzpvrk7JWQ9Ds/qgAeMACxGgg+pIc7B1AH9fKYiEuWcsbJB3feX2Dn9moK9/0+7VPLEf1ef5oHHbYYfvF5ghjGg9s8niKUjw=
Message-ID: <7579f7fb0706230954n20430e8bq4c229f72e1c32bcf@mail.gmail.com>
Date: Sat, 23 Jun 2007 09:54:08 -0700
From: "Matthew Jacob" <lydianconcepts@gmail.com>
To: "Torsten Duwe" <duwe@lst.de>
Subject: Re: How innovative is Linux?
Cc: "Grozdan Nikolov" <microchip@chello.be>, linux-kernel@vger.kernel.org
In-Reply-To: <200706231842.00798.duwe@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706231417.16086.microchip@chello.be>
	 <200706231812.02317.duwe@lst.de>
	 <200706231819.43556.microchip@chello.be>
	 <200706231842.00798.duwe@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> > hmm, wasn't loadable kernel modules first implemented in SunOS 4.x [...]
> Yes, but that was pretty cumbersome. You had to resolve the symbols in user
> space, using a hopefully matching /vmunix. Linux was first to feature an
> in-kernel linker and symbol table, IIRC.
>
>

Err, uh, no- I believe that Solaris development for this at the very
least predates even 0.59 linux- I think it was Joe Provino at Sun ECD
near Boston who gave us a working prototype in early 1989.
