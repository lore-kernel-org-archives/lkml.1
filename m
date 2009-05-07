Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbZEGH3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbZEGH3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZEGH2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:28:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbZEGH2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:28:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] do_wait: kill the old BUG_ON, use while_each_thread()
In-Reply-To: Oleg Nesterov's message of  Thursday, 7 May 2009 08:46:46 +0200 <20090507064646.GA15871@redhat.com>
References: <20090507064646.GA15871@redhat.com>
X-Windows: garbage at your fingertips.
Message-Id: <20090507072756.6BBD8FC39E@magilla.sf.frob.com>
Date: Thu,  7 May 2009 00:27:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
