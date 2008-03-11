Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbYCKCmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbYCKCmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYCKCly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:41:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbYCKCly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:41:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mt-exec && signals
In-Reply-To: Oleg Nesterov's message of  Saturday, 8 March 2008 21:05:39 +0300 <20080308180539.GA28398@tv-sign.ru>
References: <20080307095813.GA8894@tv-sign.ru>
	<20080307193159.1AFF127010F@magilla.localdomain>
	<20080307201346.GA107@tv-sign.ru>
	<20080307211955.A876226F990@magilla.localdomain>
	<20080307213217.GA2584@tv-sign.ru>
	<20080307215134.6E6BC26F990@magilla.localdomain>
	<20080308180539.GA28398@tv-sign.ru>
X-Zippy-Says: Bagels...
Message-Id: <20080311024149.DED3826F991@magilla.localdomain>
Date: Mon, 10 Mar 2008 19:41:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I'm pretty well full up on time I can allocate to figuring out this
cleanup stuff, for the next week or two anyway.  I'm very glad you're doing
it, but I don't think we can resolve the exec area all in one push now.
I don't have anything to contradict your plan about cleaning up exec.
But I'm just not able to devote enough time right now to giving it the full
consideration it requires.


Thanks,
Roland
