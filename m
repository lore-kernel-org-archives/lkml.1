Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbZFPArx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbZFPArx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 20:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbZFPArq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 20:47:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbZFPArq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 20:47:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] wait_task_zombie: do not use thread_group_cputime()
In-Reply-To: Oleg Nesterov's message of  Monday, 15 June 2009 23:26:51 +0200 <20090615212651.GA22759@redhat.com>
References: <20090615212651.GA22759@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090616004737.924DAFC3D3@magilla.sf.frob.com>
Date: Mon, 15 Jun 2009 17:47:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
