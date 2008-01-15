Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164AbYAOKty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbYAOKty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYAOKtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:49:45 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38085 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYAOKtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:49:42 -0500
Date: Tue, 15 Jan 2008 19:49:25 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH 5/5] /proc/zoneinfo enhancement
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080115104406.14ab0da7@lxorguk.ukuu.org.uk>
References: <20080115100233.117E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080115104406.14ab0da7@lxorguk.ukuu.org.uk>
Message-Id: <20080115194837.11A0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi alan

> > show new member of zone struct by /proc/zoneinfo.
> > 
> > Signed-off-by: Marcelo Tosatti <marcelo@kvack.org>
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Minor NAK - Please put new fields at the end - it makes it less likely to
> break badly written tools.

Oh I see.
I applied your opinion at next post.

Thanks!


- kosaki

