Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbYFPGWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbYFPGWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYFPGWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:22:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53673 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYFPGWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:22:41 -0400
Date: Mon, 16 Jun 2008 15:22:12 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 00/24] VM pageout scalability improvements (V12)
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <20080615232011.64925446.akpm@linux-foundation.org>
References: <20080616143034.78A1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080615232011.64925446.akpm@linux-foundation.org>
Message-Id: <20080616152134.78A6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > vmm:/home/akpm/qsbench> time ./qsbench -p 4 -m 230
> > > ./qsbench -p 4 -m 230  178.21s user 28.49s system 99% cpu 3:27.14 total
> > 
> > Where can I get this benchmark?
> 
> http://userweb.kernel.org/~akpm/qsbench.tar.gz
> 
> > I guess it is too old ;)
> 
> I might have added it - I forget.

Thanks.
I'll test this benchmark :)



