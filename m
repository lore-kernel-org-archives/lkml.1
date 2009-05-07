Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZEGHaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZEGHaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZEGHaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:30:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZEGHaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:30:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] do_wait: fix the theoretical race with stop/trace/cont
In-Reply-To: Oleg Nesterov's message of  Thursday, 7 May 2009 08:46:50 +0200 <20090507064650.GA15878@redhat.com>
References: <20090507064650.GA15878@redhat.com>
X-Shopping-List: (1) Luxuriant gravy stones
   (2) Frivolous rebellious checks
   (3) Pharmaceutical benediction immunizations
   (4) Convenient exclusions
   (5) Irritating resurgent welts
Message-Id: <20090507072907.06FBFFC39E@magilla.sf.frob.com>
Date: Thu,  7 May 2009 00:29:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
