Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab0BSOYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 09:24:43 -0500
Received: from zimbra.ccs.neu.edu ([129.10.116.59]:46173 "EHLO
	zimbra.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0BSOYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 09:24:42 -0500
Date: Fri, 19 Feb 2010 09:24:34 -0500 (EST)
From: Ari Entlich <atrigent@ccs.neu.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <13370047.143711266589474879.JavaMail.root@zimbra>
In-Reply-To: <26133453.143601266589400174.JavaMail.root@zimbra>
Subject: Re: [PATCH] Add a new VT mode which is like VT_PROCESS but doesn't
 require a VT_RELDISP ioctl call
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [129.10.223.88]
X-Mailer: Zimbra 5.0.22_GA_3210.UBUNTU6 (ZimbraWebClient - FF3.0 (Linux)/5.0.22_GA_3210.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Alan Cox" <alan@lxorguk.ukuu.org.uk> wrote:
> That would just as well. It just needs to be obvious for future
> maintainers that the overlap doesn't matter

Alright, cool. Should I submit two patches (one for the define move
and one for the actual patch), or would one patch be fine?

Ari
