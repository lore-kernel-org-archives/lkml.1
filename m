Return-Path: <linux-kernel-owner+w=401wt.eu-S1764343AbYCFLLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764343AbYCFLLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbYCFLLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:11:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbYCFLLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:11:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] __group_complete_signal: cache the value of p->signal
In-Reply-To: Oleg Nesterov's message of  Thursday, 6 March 2008 01:43:20 +0300 <20080305224320.GA6342@tv-sign.ru>
References: <20080305224320.GA6342@tv-sign.ru>
X-Windows: no hardware is safe.
Message-Id: <20080306111002.7558E2700FD@magilla.localdomain>
Date: Thu,  6 Mar 2008 03:10:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks perfectly fine, fully cosmetic.


Thanks,
Roland
