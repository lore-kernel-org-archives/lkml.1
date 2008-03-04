Return-Path: <linux-kernel-owner+w=401wt.eu-S1764080AbYCDIlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764080AbYCDIlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763812AbYCDIkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:40:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763898AbYCDIki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:40:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] introduce task_detached() helper
In-Reply-To: Oleg Nesterov's message of  Monday, 3 March 2008 08:11:38 +0300 <20080303051138.GA23635@tv-sign.ru>
References: <20080303041749.GA18911@tv-sign.ru>
	<20080303043749.GA13040@infradead.org>
	<20080303051138.GA23635@tv-sign.ru>
X-Shopping-List: (1) Nonchalant concussions
   (2) Inelegant gongs
   (3) Sophomoric mound hamster-lips
   (4) Felonious carrion competitors
Message-Id: <20080304084004.4ABC327010A@magilla.localdomain>
Date: Tue,  4 Mar 2008 00:40:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.  I always found the exit_signal == -1 checks rather
overly magical to be sprinkled around so much.

Thanks,
Roland
