Return-Path: <linux-kernel-owner+w=401wt.eu-S1763915AbXHQJFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763915AbXHQJFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 05:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbXHQJFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 05:05:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:32943 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758032AbXHQJFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 05:05:32 -0400
Date: Fri, 17 Aug 2007 02:05:30 -0700
From: Paul Jackson <pj@sgi.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: anandjigar@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Patch
Message-Id: <20070817020530.29935240.pj@sgi.com>
In-Reply-To: <46C5514C.4010605@suse.cz>
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
	<1187250004.12446.3.camel@elijah.suse.cz>
	<20070817001954.38010df3.pj@sgi.com>
	<46C5514C.4010605@suse.cz>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I agree that (1) one risks overdoing comments and (2) one should minimize
comments inside a function body.

But I read your earlier statement:

  Please do not add comments inside functions.

as simply requesting no comments inside function bodies, without
exception.  That seems to me to be too strong a statement.

The "try to avoid" in the CodingStyle I read as meaning roughly
"minimize" which is consistent with what it further states, allowing
for "small comments" in certain cases.

Admittedly, I probably agree with you that the command that Anand
added in his patch was one of those comments that didn't add enough
value to be justified.

I was just quibbling over the wording of your objections to it.

 ... I'll shut up now.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
