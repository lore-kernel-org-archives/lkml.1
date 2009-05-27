Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbZE0X5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbZE0X5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761490AbZE0X5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:57:25 -0400
Received: from mail.samba.org ([66.70.73.150]:58468 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761175AbZE0X5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:57:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18973.54100.522638.314377@samba.org>
Date: Thu, 28 May 2009 09:57:08 +1000
To: vimal singh <vimal.newwork@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
In-Reply-To: <ce9ab5790905270505i530febcerfda874f5049c6c93@mail.gmail.com>
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	<87fxfnbytu.fsf@devron.myhome.or.jp>
	<87ws8zak1m.fsf@devron.myhome.or.jp>
	<87bpqbaji9.fsf@devron.myhome.or.jp>
	<18940.9039.850580.48730@samba.org>
	<87ab5v9381.fsf@devron.myhome.or.jp>
	<18940.10942.989329.993465@samba.org>
	<87ocub7ngh.fsf@devron.myhome.or.jp>
	<18940.12667.429391.927727@samba.org>
	<8763gj7m23.fsf@devron.myhome.or.jp>
	<ce9ab5790905270505i530febcerfda874f5049c6c93@mail.gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vimal,

 > Any conclusion has been reached reagarding this patch...?

We've been working to resolve some of the issues people raised (for
example, a public explanation on why the patch is needed). We have
also been working towards an improved version of the patch. Sorry it's
taking so long, but we hope to be able to post a new patch soon.

Cheers, Tridge
