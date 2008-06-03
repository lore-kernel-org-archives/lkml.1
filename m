Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYFCV7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYFCV7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYFCV7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:59:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbYFCV7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:59:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: dequeue_signal: don't check SIGNAL_GROUP_EXIT when setting SIGNAL_STOP_DEQUEUED
In-Reply-To: Oleg Nesterov's message of  Saturday, 31 May 2008 20:15:29 +0400 <20080531161529.GA5563@tv-sign.ru>
References: <20080531161529.GA5563@tv-sign.ru>
X-Shopping-List: (1) Partial Celtic trash pretenders
   (2) Diaphanous destroyer breath
   (3) Imprudent gravy
   (4) Virulent bruisers
Message-Id: <20080603215846.46F3526FC96@magilla.localdomain>
Date: Tue,  3 Jun 2008 14:58:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
