Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbXBRVQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbXBRVQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 16:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXBRVQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 16:16:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:21936 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbXBRVQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 16:16:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tKiBMuG2Cdy72i+gqI9WHMI00gMcNGo98pfGTZNyCEJHwyZZ/6VgJNQy2UTGHooyKKYiCP2m/fc261k75VQqo4PBSSJjsqLvBDZCytcgmqsF22iT5U8HkYLG9Og+WW60iQXuZJQcH2AiMUHxPZNbwQAVGxbPNhXrsgXoUsZA+XY=
Message-ID: <3d57814d0702181316k1b1dfc1en710c9c4a88e05476@mail.gmail.com>
Date: Mon, 19 Feb 2007 07:16:55 +1000
From: "Trent Waddington" <trent.waddington@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>,
       "Trent Waddington" <trent.waddington@gmail.com>,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       "Neil Brown" <neilb@suse.de>, davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: <20070218135719.GB20321@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070216125353.GN13958@stusta.de>
	 <MDEHLPKNGKAHNMBLJOLKKEIMBKAC.davids@webmaster.com>
	 <17878.48376.629016.49202@notabene.brown>
	 <f2b55d220702171855u59e3cc47i73e4aa48d0c0968c@mail.gmail.com>
	 <3d57814d0702171926v53812baeqaeeda326aa225acf@mail.gmail.com>
	 <20070218135719.GB20321@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/07, Theodore Tso <tytso@mit.edu> wrote:
> Actually, the FSF and many of its representatives, has claimed, on
> many occassions, that the GPL infects across dynamic linking.  That
> is, if you write your own code that calls readline which links via a
> dynamically linked shared library, and perhaps even across dlopen(),
> they claim that the GPL applies to the code which you write.  Given
> that the only way this could happen is via copyright law, they are
> basically saying that if you use the readline interface, you have
> created a derived work and they therefore 0wn your source code.

Is that so?

> Whether or not this would be laughed out of court or not will very
> much depend on the local legal precedents (and Trent Waddington has
> quoted some very interesting legal cases based on US court decisions,

Wow?  I did?  Really?  I must have been sleep typing.

Trent
