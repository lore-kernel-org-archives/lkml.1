Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbYEAMlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbYEAMlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYEAMlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:41:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50047 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbYEAMli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:41:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 14:41:05 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011338.34735.rjw@sisk.pl> <20080430072822.4d931a3c@infradead.org>
In-Reply-To: <20080430072822.4d931a3c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011441.07286.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 of April 2008, Arjan van de Ven wrote:
> On Thu, 1 May 2008 13:38:33 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > BTW, we seem to underestimate testing in this discussion.  In fact,
> > the vast majority of kernel bugs are discovered by testing, so
> > perhaps the way to go is to make regular testing of the new code a
> > part of the process.
> 
> well.. -rc1 to -rc8 are doing that already, somewhat.

Somewhat.

> Can we do better? Always. The more testing the better, and the more
> testers the better.

The testing is not really a part of the process right now, though.  We somehow
hope that the kernel will be tested sufficiently before a major release, but
we don't measure the testing coverage, for example.  Of course, that will
involve more work independent of the code writing, but at one point it'll
just become a necessity.

Thanks,
Rafael
