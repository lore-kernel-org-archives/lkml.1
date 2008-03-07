Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbYCGTGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbYCGTGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbYCGTF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:05:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbYCGTFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:05:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: move handle_stop_signal() into send_signal()
In-Reply-To: Oleg Nesterov's message of  Friday, 7 March 2008 10:45:43 +0300 <20080307074543.GA6020@tv-sign.ru>
References: <20080307074543.GA6020@tv-sign.ru>
Emacs: freely redistributable; void where prohibited by law.
Message-Id: <20080307190515.A084527010F@magilla.localdomain>
Date: Fri,  7 Mar 2008 11:05:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks ok to me.


Thanks,
Roland
