Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbZHXJQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbZHXJQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZHXJQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:16:44 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:59133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751693AbZHXJQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:16:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race copy_process() vs de_thread()
In-Reply-To: Oleg Nesterov's message of  Monday, 24 August 2009 10:53:31 +0200 <20090824085331.GB475@redhat.com>
References: <4A9210A4.4010108@ct.jp.nec.com>
	<20090824061420.341A9414DF@magilla.sf.frob.com>
	<4A923403.6010201@ct.jp.nec.com>
	<20090824083826.GA475@redhat.com>
	<20090824085331.GB475@redhat.com>
X-Shopping-List: (1) Gregarious persecuters
   (2) Expandable omnipresent money longitudes
   (3) Reddy-Mix Flossbag potions
Message-Id: <20090824091558.BDAFE414DF@magilla.sf.frob.com>
Date: Mon, 24 Aug 2009 02:15:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I like your first patch better.  It's a larger patch, but that's
because it winds up with smaller code.


Thanks,
Roland
