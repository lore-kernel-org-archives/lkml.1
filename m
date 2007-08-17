Return-Path: <linux-kernel-owner+w=401wt.eu-S1761380AbXHQHUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761380AbXHQHUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbXHQHT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:19:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57546 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753264AbXHQHT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:19:58 -0400
Date: Fri, 17 Aug 2007 00:19:54 -0700
From: Paul Jackson <pj@sgi.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: anandjigar@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Patch
Message-Id: <20070817001954.38010df3.pj@sgi.com>
In-Reply-To: <1187250004.12446.3.camel@elijah.suse.cz>
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
	<1187250004.12446.3.camel@elijah.suse.cz>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Petr wrote:
> Please do not add comments inside functions.

I find this advice a bit odd.  I am not aware of
any prohibition of comments inside functions.

As with comments outside functions, they should
serve a worthwhile purpose, of course.  One might
debate whether this particular comment added by
Anand was sufficiently valuable to be worth
having.

But I don't agree to a blanket prohibition on
comments inside functions.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
