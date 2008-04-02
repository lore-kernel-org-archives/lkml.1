Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYDBK5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYDBK5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbYDBK5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:57:03 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59617 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbYDBK5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:57:00 -0400
Date: Wed, 02 Apr 2008 19:56:05 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: GFP_ATOMIC page allocation failures.
Cc: kosaki.motohiro@jp.fujitsu.com, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, csnook@redhat.com, davej@codemonkey.org.uk,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Michael Chan <mchan@broadcom.com>
In-Reply-To: <20080402175857.959A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080402.012406.246863209.davem@davemloft.net> <20080402175857.959A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080402195428.95A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> ---------------------------------------------------------------------
> We get rather a lot of reports of page allocation warnings coming out of
> tg3.  But this driver is know to handle them properly so let's suppress
> them.

BTW:
other person's tg3 allocation failure bug report.

http://bugzilla.kernel.org/show_bug.cgi?id=9771



