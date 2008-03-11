Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbYCKCUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbYCKCUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYCKCU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:20:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbYCKCU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:20:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: cleanup the usage of print_fatal_signal()
In-Reply-To: Oleg Nesterov's message of  Tuesday, 11 March 2008 00:17:44 +0300 <20080310211744.GA1580@tv-sign.ru>
References: <20080310211744.GA1580@tv-sign.ru>
X-Shopping-List: (1) Famous cheese cushions
   (2) Benevolent comical dividers
   (3) Delicious crossword aggressors
   (4) Satirical division condensers
Message-Id: <20080311022024.941AD26F991@magilla.localdomain>
Date: Mon, 10 Mar 2008 19:20:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks right to me.  I'd prefer to see a comment before the added lines
and a blank line after them, though.


Thanks,
Roland
