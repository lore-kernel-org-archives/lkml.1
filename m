Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbYFDE0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbYFDE0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYFDEZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:25:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37325 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYFDEZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:25:51 -0400
Date: Wed, 04 Jun 2008 13:26:17 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Subject: Re: [PATCH 4/4] per-task-delay-accounting: /proc export for memory reclaim delay
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080603211142.c0977893.kobayashi.kk@ncos.nec.co.jp>
References: <20080604120235.940B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080603211142.c0977893.kobayashi.kk@ncos.nec.co.jp>
Message-Id: <20080604132513.9414.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > ----------------------------------------
> > #!/usr/bin/perl
> > 
> > $stat = `cat /proc/$pid/stat`;
> > @stat_list = split(/ / , $stat);
> > print stat_list[$index];
> >                  ^
> >                  |
> >                  use array index number
> 
> Certainly, it makes sense.
> I thought this measurement value should be put
> beside other delay account.

Yeah, I'm looking forward to your v2 :)

Thanks!


