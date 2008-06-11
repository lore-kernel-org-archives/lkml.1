Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbYFKGhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbYFKGhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 02:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYFKGhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 02:37:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35832 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYFKGhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:37:07 -0400
Date: Wed, 11 Jun 2008 15:36:40 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc5-mm2: OOM with 1G free swap
Cc: kosaki.motohiro@jp.fujitsu.com, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20080610232705.3aaf5c06.akpm@linux-foundation.org>
References: <20080611060029.GA5011@martell.zuzino.mipt.ru> <20080610232705.3aaf5c06.akpm@linux-foundation.org>
Message-Id: <20080611153457.7882.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > vm.overcommit_memory = 0
> > vm.overcommit_ratio = 50
> 
> Well I assume that Rik ran LTP.  Perhaps a merge problem.

at least, I ran LTP last week and its error didn't happend.
I'll investigate more.

Thanks.




