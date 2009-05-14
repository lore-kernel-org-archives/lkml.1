Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbZENSzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbZENSzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 14:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbZENSze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 14:55:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbZENSzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 14:55:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Completely replace wait_noreap_copyout() by copy_wait_opts_to_user()
In-Reply-To: Vitaly Mayatskikh's message of  Thursday, 14 May 2009 11:50:13 +0200 <1242294612-28680-2-git-send-email-v.mayatskih@gmail.com>
References: <1242294612-28680-1-git-send-email-v.mayatskih@gmail.com>
	<1242294612-28680-2-git-send-email-v.mayatskih@gmail.com>
X-Shopping-List: (1) Pungent friction
   (2) Idyllic carnations
   (3) Rheumatic imports
   (4) Excellent prescriptions
Message-Id: <20090514185519.330B3FC35D@magilla.sf.frob.com>
Date: Thu, 14 May 2009 11:55:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the return value of copy_wait_opts_to_user without changing
all its callers to match.


Thanks,
Roland
