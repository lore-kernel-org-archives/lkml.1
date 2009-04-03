Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbZDCPsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbZDCPsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934338AbZDCPqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:46:16 -0400
Received: from rtr.ca ([76.10.145.34]:55242 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934257AbZDCPqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:46:15 -0400
Message-ID: <49D62F45.4000007@rtr.ca>
Date: Fri, 03 Apr 2009 11:46:13 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Janne Grunau <j@jannau.net>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel> <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org> <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain> <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain> <49D627DF.6090501@rtr.ca> <20090403151812.GK3795@csclub.uwaterloo.ca>
In-Reply-To: <20090403151812.GK3795@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Fri, Apr 03, 2009 at 11:14:39AM -0400, Mark Lord wrote:
>> Note that for mythtv, this may not be the best behaviour.
>>
>> A common use scenario is "watching live TV", a few minutes behind
>> real-time so that the commercial-skipping can work its magic.
> 
> Well I really never watch live TV.
..

A *true* myth dev!  (pretenders use LiveTV, *real* devs don't!)

But mythcommflag also benefits from having the pages
hang around for an extra short time.

Cheers
