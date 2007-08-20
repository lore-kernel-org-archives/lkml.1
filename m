Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbXHTCDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbXHTCDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 22:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbXHTCCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 22:02:13 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:26099 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513AbXHTCCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 22:02:08 -0400
Date: Mon, 20 Aug 2007 11:02:01 +0900 (JST)
Message-Id: <20070820.110201.126143108.nemoto@toshiba-tops.co.jp>
To: david-b@pacbell.net
Cc: kay.sievers@vrfy.org, jengelh@computergmbh.de, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       greg@kroah.com, david@fubar.dk
Subject: Re: legacy platform drivers and hotplugging
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <200708191844.43947.david-b@pacbell.net>
References: <200708172106.52940.david-b@pacbell.net>
	<1187433939.4419.42.camel@lov.localdomain>
	<200708191844.43947.david-b@pacbell.net>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2007 18:44:43 -0700, David Brownell <david-b@pacbell.net> wrote:
> Notice I fixed $SUBJECT to not mention rtc-ds1742, which has
> never been a platform device and thus is offtopic to your
> specific complaints about platform bus hotplugging.

Well, rtc-ds1742 *IS* a platform driver.  But it seems the discussion
is not DS1742 specific at all, and I guess ds1742 is not a good
example for hotplugging, so I welcome your $SUBJECT fix :-)

---
Atsushi Nemoto
