Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbYDYEay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbYDYEay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 00:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYDYEao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 00:30:44 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44550 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbYDYEan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 00:30:43 -0400
Date: Fri, 25 Apr 2008 08:29:57 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] socket, socketpair w/flags, accept4
Message-ID: <20080425042957.GA17699@2ka.mipt.ru>
References: <200804241820.m3OIKlMK017580@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804241820.m3OIKlMK017580@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, Apr 24, 2008 at 02:20:47PM -0400, Ulrich Drepper (drepper@redhat.com) wrote:
> The code changes are really minimal.  And don't get too hung up on the
> internal name of the syscall.  I think accept4 is more desriptive than
> paccept since a) suffixes more easily indicate derived functionality
> and b) the 4 actually indicates to the initiated what has changed.
> If there are good reasons otherwise the userlevel interface can still
> be something completely different.

What about sigset there too?

-- 
	Evgeniy Polyakov
