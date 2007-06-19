Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbXFSPCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbXFSPCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbXFSPCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:02:36 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:52351 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbXFSPCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:02:35 -0400
Date: Wed, 20 Jun 2007 00:03:07 +0900 (JST)
Message-Id: <20070620.000307.106261623.anemo@mba.ocn.ne.jp>
To: alessandro.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [rtc-linux] RTC_CLASS is still considered as EXPERIMENTAL?
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20070619140919.0a273429@inspiron>
References: <20070616.011037.59464869.anemo@mba.ocn.ne.jp>
	<20070615201959.26666815@inspiron>
	<20070619140919.0a273429@inspiron>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 14:09:19 +0200, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
> > > It is mature enough to remove EXPERIMENTAL label from RTC_CLASS, isn't
> > > it?
> > 
> >  I'd say yes, I will submit a patch. ty.
> 
>  RTC class is mature enough.
> 
>  Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>

Thanks.  I suppose this helps dropping CONFIG_EXPERIMENTAL from some
defconfigs.

---
Atsushi Nemoto
