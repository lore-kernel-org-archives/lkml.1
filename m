Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbZHXRGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbZHXRGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZHXRF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:05:59 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:34062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752660AbZHXRF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:05:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, stable@kernel.org
Subject: Re: [PATCH v3] fix race copy_process() vs de_thread()
In-Reply-To: Oleg Nesterov's message of  Monday, 24 August 2009 18:27:30 +0200 <20090824162730.GA14367@redhat.com>
References: <4A9210A4.4010108@ct.jp.nec.com>
	<20090824061420.341A9414DF@magilla.sf.frob.com>
	<4A923403.6010201@ct.jp.nec.com>
	<20090824083826.GA475@redhat.com>
	<20090824162730.GA14367@redhat.com>
Emacs: (setq software-quality (/ 1 number-of-authors))
Message-Id: <20090824165701.D51AA414DF@magilla.sf.frob.com>
Date: Mon, 24 Aug 2009 09:57:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
