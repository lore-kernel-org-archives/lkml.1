Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYG1Q3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYG1Q3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbYG1Q2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:28:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57103 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759132AbYG1Q2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:28:50 -0400
Date: Tue, 29 Jul 2008 01:27:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: righi.andrea@gmail.com
Subject: Re: [PATCH 1/1] mm: unify pmd_free() implementation
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <488DF119.2000004@gmail.com>
References: <alpine.LFD.1.10.0807280851130.3486@nehalem.linux-foundation.org> <488DF119.2000004@gmail.com>
Message-Id: <20080729012656.566F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> yep! clear.
> 
> Ok, in this case wouldn't be better at least to define pud_free() as:
> 
> static inline pud_free(struct mm_struct *mm, pmd_t *pmd)
> {
> }

I also like this :)



