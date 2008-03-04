Return-Path: <linux-kernel-owner+w=401wt.eu-S1763947AbYCDIkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763947AbYCDIkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763183AbYCDIjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:39:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763128AbYCDIjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:39:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] document de_thread() with exit_notify() connection
In-Reply-To: Oleg Nesterov's message of  Monday, 3 March 2008 07:17:55 +0300 <20080303041755.GA18920@tv-sign.ru>
References: <20080303041755.GA18920@tv-sign.ru>
X-Windows: a mistake carried out to perfection.
Message-Id: <20080304083847.BD60627010A@magilla.localdomain>
Date: Tue,  4 Mar 2008 00:38:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's better than nothing!  I'd still like to revisit the whole MT exec
picture when we can.

Thanks,
Roland
