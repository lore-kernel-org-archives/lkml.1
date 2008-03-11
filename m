Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbYCKCJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbYCKCJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbYCKCIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:08:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222AbYCKCIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:08:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] signals: join send_sigqueue() with send_group_sigqueue()
In-Reply-To: Oleg Nesterov's message of  Saturday, 8 March 2008 18:10:26 +0300 <20080308151026.GA25194@tv-sign.ru>
References: <20080308151026.GA25194@tv-sign.ru>
X-Zippy-Says: ..  he dominates the DECADENT SUBWAY SCENE.
Message-Id: <20080311020819.1E71E26F991@magilla.localdomain>
Date: Mon, 10 Mar 2008 19:08:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.
