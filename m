Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbYEAM2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbYEAM2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYEAM2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:28:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53944 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYEAM2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:28:38 -0400
Date: Wed, 30 Apr 2008 07:28:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080430072822.4d931a3c@infradead.org>
In-Reply-To: <200805011338.34735.rjw@sisk.pl>
References: <20080429.190352.137408408.davem@davemloft.net>
	<alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org>
	<alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org>
	<200805011338.34735.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 13:38:33 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> BTW, we seem to underestimate testing in this discussion.  In fact,
> the vast majority of kernel bugs are discovered by testing, so
> perhaps the way to go is to make regular testing of the new code a
> part of the process.

well.. -rc1 to -rc8 are doing that already, somewhat.
Can we do better? Always. The more testing the better, and the more
testers the better. 
