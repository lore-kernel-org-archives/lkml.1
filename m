Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab0BAUIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:08:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab0BAUIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:08:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@lst.de>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, akpm@linux-foundation.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]: mark ptrace_traceme static
In-Reply-To: Christoph Hellwig's message of  Monday, 1 February 2010 20:18:55 +0100 <20100201191855.GA11874@lst.de>
References: <20100201191855.GA11874@lst.de>
X-Shopping-List: (1) Hesitant rain-making button livers
   (2) Independent metronome fission
   (3) Starboard commendations
Message-Id: <20100201200834.4BD0CC82F@magilla.sf.frob.com>
Date: Mon,  1 Feb 2010 12:08:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's not used outside of ptrace.c, so no need to allow access to it.

Acked-by: Roland McGrath <roland@redhat.com>
