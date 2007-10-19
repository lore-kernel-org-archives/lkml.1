Return-Path: <linux-kernel-owner+w=401wt.eu-S967227AbXJSWW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967227AbXJSWW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXJSWWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:22:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:31043 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760718AbXJSWWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=LDB6P4Ftv8y4+zfsOSw95qYQBokmhYJmtmj9Pg8+o6S5qCTAZDE1rMmMH3lm8ouy3Bqp0ZRjcReMDgMnWxpTK1ECQKlf2uTFJUzvZ8ekQQIvZoF4dOrFigBO+2upASppO/CpWun5vmyHg0MvlTAlhj4d85PG1QAIjNJUuyJRgXk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: nick@ukfsn.org
Subject: Re: New CD/DVD drive - 80-wire cable detection failure
Date: Sat, 20 Oct 2007 00:28:21 +0200
User-Agent: KMail/1.9.7
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200710181832.42906.nick@ukfsn.org> <200710192344.27312.bzolnier@gmail.com> <200710192304.23749.nick@ukfsn.org>
In-Reply-To: <200710192304.23749.nick@ukfsn.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710200028.21860.bzolnier@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 October 2007, Nick Warne wrote:
> On Friday 19 October 2007 22:44:27 Bartlomiej Zolnierkiewicz wrote:

> hdparm -I

It should have been hdparm --Istdout (sorry, once again).

[ It is definitevely not my day, or rather trying to debug the problem
  while preparing the next IDE pull request is not a such good idea... ]

>From identify data we should be able to deduce whether this is a kernel
problem or rather a hardware/configuration one.

Thanks,
Bart
