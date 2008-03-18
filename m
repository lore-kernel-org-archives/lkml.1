Return-Path: <linux-kernel-owner+w=401wt.eu-S1162648AbYCSXA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162648AbYCSXA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932160AbYCSVZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:25:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886AbYCSVZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:25:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: ptrace_attach: use send_sig_info() instead force_sig_specific()
In-Reply-To: Oleg Nesterov's message of  Tuesday, 18 March 2008 19:33:20 +0300 <20080318163320.GA5106@tv-sign.ru>
References: <20080318163320.GA5106@tv-sign.ru>
X-Shopping-List: (1) Pneumatic erosion champions
   (2) Symphonic bug yies
   (3) Disastrous tape
   (4) Archaic itinerant attention
   (5) Titanic lasers
Message-Id: <20080318220924.9EDAA26F995@magilla.localdomain>
Date: Tue, 18 Mar 2008 15:09:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks right to me.

Thanks,
Roland
