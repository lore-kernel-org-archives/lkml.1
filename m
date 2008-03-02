Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbYCBSlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbYCBSlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYCBSlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:41:07 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:44215 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYCBSlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:41:07 -0500
Date: Sun, 2 Mar 2008 21:44:30 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@redhat.com>, Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] orphaned pgrp fixes
Message-ID: <20080302184430.GA16362@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This code is absolutely, completely broken. I guess this is because it
wasn't updated when linux got threads.

I don't really understand this magic, and I don't know who maintains it
Please review.

Oleg.

