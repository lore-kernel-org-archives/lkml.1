Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZBJMzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZBJMzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbZBJMzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:55:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56411 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZBJMzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:55:01 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 2/2] don't compile SGI XP/GRU on ia64_generic
Cc: kosaki.motohiro@jp.fujitsu.com, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Dean Nelson <dcn@sgi.com>
In-Reply-To: <20090210125157.GT8577@sgi.com>
References: <20090210210110.7001.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090210125157.GT8577@sgi.com>
Message-Id: <20090210215338.700A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 21:54:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Dean Nelson submitted a patch yesterday to make this work.
> 
> Robin

Thanks!
I'm happy a lot.


> 
> 
> On Tue, Feb 10, 2009 at 09:03:40PM +0900, KOSAKI Motohiro wrote:
> > Subject: [PATCH] ia64: don't compile SGI-XP on ia64 generic.
> > Impact: fix build error
> > 
> > Currently sgi-xp driver depend on "uv.h" header file.
> > but only x86 have "uv.h" header.
> > 
> > Then, ia64 hit following build error.



