Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbXEIMww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbXEIMww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbXEIMwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:52:44 -0400
Received: from ns.suse.de ([195.135.220.2]:38488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbXEIMwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:52:43 -0400
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 4/4] Add common orderly_poweroff()
Date: Wed, 9 May 2007 14:52:25 +0200
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Len Brown <lenb@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
References: <20070508205129.064843364@goop.org> <20070508205517.358968475@goop.org>
In-Reply-To: <20070508205517.358968475@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705091452.26230.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 May 2007 22:51, Jeremy Fitzhardinge wrote:
> Various pieces of code around the kernel want to be able to trigger an
> orderly poweroff.  This pulls them together into a single
> implementation.

Fine for me from the x86 side.

-Andi
