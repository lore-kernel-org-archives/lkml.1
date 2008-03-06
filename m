Return-Path: <linux-kernel-owner+w=401wt.eu-S1763111AbYCFKyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763111AbYCFKyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbYCFKym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:54:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758128AbYCFKyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:54:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 1/2] signals: re-assign CLD_CONTINUED notification from the sender to reciever
In-Reply-To: Oleg Nesterov's message of  Tuesday, 4 March 2008 21:57:44 +0300 <20080304185744.GA8479@tv-sign.ru>
References: <20080304185744.GA8479@tv-sign.ru>
Emacs: ballast for RAM.
Message-Id: <20080306105316.631552700FD@magilla.localdomain>
Date: Thu,  6 Mar 2008 02:53:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like this version fine, but I would like to see that comment in
get_signal_to_deliver added in a cleanup patch.


Thanks,
Roland
