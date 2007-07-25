Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbXGYE55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbXGYE55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 00:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbXGYE5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 00:57:50 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:33654 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbXGYE5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 00:57:50 -0400
Message-ID: <46A6D7D2.4050708@gmail.com>
Date: Wed, 25 Jul 2007 06:55:46 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	 <200707102015.44004.kernel@kolivas.org>	 <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	 <46A57068.3070701@yahoo.com.au>	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>	 <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com> <46A6CC56.6040307@yahoo.com.au>
In-Reply-To: <46A6CC56.6040307@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2007 06:06 AM, Nick Piggin wrote:

> Ray Lee wrote:

>> Anyway, my point is that I worry that tuning for an unusual and 
>> infrequent workload (which updatedb certainly is), is the wrong way to 
>> go.
> 
> Well it runs every day or so for every desktop Linux user, and it has
> similarities with other workloads.

It certainly doesn't run for me ever. Always kind of a "that's not the 
point" comment but I just keep wondering whenever I see anyone complain 
about updatedb why the _hell_ they are running it in the first place. If 
anyone who never uses "locate" for anything simply disable updatedb, the 
problem will for a large part be solved.

This not just meant as a cheap comment; while I can think of a few similar 
loads even on the desktop (scanning a browser cache, a media player indexing 
a large amount of media files, ...) I've never heard of problems _other_ 
than updatedb. So just junk that crap and be happy.

Rene.
