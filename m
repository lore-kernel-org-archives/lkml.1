Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbYE3J2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbYE3J2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYE3J2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:28:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55634 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbYE3J2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:28:08 -0400
Date: Fri, 30 May 2008 18:27:09 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [PATCH 00/25] Vm Pageout Scalability Improvements (V8) - continued
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Eric Whitney <eric.whitney@hp.com>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080529195030.27159.66161.sendpatchset@lts-notebook>
References: <20080529195030.27159.66161.sendpatchset@lts-notebook>
Message-Id: <20080530182408.777F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The entire stack, including Rik's split lru patches, are holding up very
> well under stress loads.  E.g., ran for over 90+ hours over the weekend on
> both x86_64 [32GB, 8core] and ia64 [32GB, 16cpu] platforms without error
> over last weekend.  

Note:
On fujitsu server(IA64 8CPU 8GB), this patch series works well 48+ hours too :)



