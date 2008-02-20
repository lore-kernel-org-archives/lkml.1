Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbYBTFXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbYBTFXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYBTFXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:23:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44038 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYBTFXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:23:31 -0500
Date: Wed, 20 Feb 2008 14:21:37 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Cc: kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, pavel@ucw.cz,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, marcelo@kvack.org,
       daniel.spang@gmail.com, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-fsdevel@vger.kernel.org,
       a1426z@gawab.com, jonathan@jonmasters.org, zlynx@acm.org
In-Reply-To: <20080219225733.37c56eb2.pj@sgi.com>
References: <20080220114317.642F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080219225733.37c56eb2.pj@sgi.com>
Message-Id: <20080220141329.6435.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Did those jobs share nodes -- sometimes two or more jobs using the same
> nodes?  I am sure SGI has such users too, though such job mixes make
> the runtimes of specific jobs less obvious, so customers are more
> tolerant of variations and some inefficiencies, as they get hidden in
> the mix.

Hm
our dedicated ndoe user set memory limit to machine physical memory
size (minus a bit).

I think don't have so much share/dedicate and watch user-defined/swap.
am i misundestand?


