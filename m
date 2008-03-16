Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYCPXDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYCPXDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYCPXDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:03:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYCPXDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:03:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] /sbin/init && signals fixes
In-Reply-To: Oleg Nesterov's message of  Sunday, 16 March 2008 18:53:25 +0300 <20080316155325.GA20833@tv-sign.ru>
References: <20080316155325.GA20833@tv-sign.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080316230244.B762526F995@magilla.localdomain>
Date: Sun, 16 Mar 2008 16:02:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we need to keep the magic special treatment of init,
then these three patches look like a good cleanup to me.


Thanks,
Roland
