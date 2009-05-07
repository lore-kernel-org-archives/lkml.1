Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbZEGStZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbZEGStZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZEGStP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:49:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbZEGStO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:49:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Chris Wright <chrisw@sous-sol.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch 2/2] ptrace: turn ptrace_access_check() into a retval
	function
In-Reply-To: Ingo Molnar's message of  Thursday, 7 May 2009 11:50:54 +0200 <20090507095054.GB4911@elte.hu>
References: <20090506080050.GF17457@elte.hu>
	<20090506235349.GC3756@redhat.com>
	<20090507002133.02D05FC39E@magilla.sf.frob.com>
	<20090507063606.GA15220@redhat.com>
	<20090507082027.GD12285@elte.hu>
	<20090507083102.GA20125@redhat.com>
	<20090507083851.GA19133@elte.hu>
	<20090507085742.GB3036@sequoia.sous-sol.org>
	<20090507090459.GE19133@elte.hu>
	<20090507093124.GA355@elte.hu>
	<20090507095054.GB4911@elte.hu>
X-Shopping-List: (1) Political chromatic yies
   (2) Independent ambition
   (3) Revised felonious suction
   (4) Cognizant birds
   (5) Unanimous abrasion rotators
Message-Id: <20090507184716.73D96FC39E@magilla.sf.frob.com>
Date: Thu,  7 May 2009 11:47:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
