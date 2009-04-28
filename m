Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZD1Uxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZD1Uxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbZD1UxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:53:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:48022 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237AbZD1UxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:53:22 -0400
Subject: Re: Please revert edada399 and 9203fc9c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tim Abbott <tabbott@MIT.EDU>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20090428083528.GA17622@uranus.ravnborg.org>
References: <18934.35969.872225.70725@cargo.ozlabs.ibm.com>
	 <20090428083528.GA17622@uranus.ravnborg.org>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 06:52:27 +1000
Message-Id: <1240951947.15263.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 10:35 +0200, Sam Ravnborg wrote:

> This is partly my fault :-(
> I acked them as I did not see the issue with conditional branches.
> Could I ask you to add a comment to the lds file about this.

I'm back :-)

Not a huge deal per-se, it's just that the patches were merged in Linus
tree only a few hours after being initially submitted it seems, which
doesn't leave much chance for anybody to test, to hit -next, or anything
like that... that was a little bit too trigger happy .

Cheers,
Ben.


