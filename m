Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbYAOK7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbYAOK7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYAOK7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:59:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35591 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYAOK7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:59:23 -0500
Date: Tue, 15 Jan 2008 19:59:02 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080115104619.10dab6de@lxorguk.ukuu.org.uk>
References: <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080115104619.10dab6de@lxorguk.ukuu.org.uk>
Message-Id: <20080115195022.11A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > the core of this patch series.
> > add /dev/mem_notify device for notification low memory to user process.
> 
> As you only wake one process how would you use this API from processes
> which want to monitor and can free memory under load. Also what fairness
> guarantees are there...

Sorry, I don't make sense what you mean fairness.
Could you tell more?




