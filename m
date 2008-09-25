Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYIYSgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYIYSgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYIYSgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:36:43 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:40400 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752919AbYIYSgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:36:43 -0400
Date: Thu, 25 Sep 2008 22:36:41 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linuxppc-dev@ozlabs.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kumar Gala <galak@kernel.crashing.org>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] QE Pin Multiplexing API
Message-ID: <20080925183641.GA20037@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the sketch, only for RFC. It is tested to work, but there could be
silly thinkos anyway. I'll review the changes once again later...

Anyhow... David, is this approach looks ok? Or I'm hopeless..? ;-)

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
