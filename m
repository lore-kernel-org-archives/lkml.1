Return-Path: <linux-kernel-owner+w=401wt.eu-S934789AbXGYTUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789AbXGYTUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934931AbXGYTUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:20:18 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55863 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934713AbXGYTUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:20:16 -0400
Date: Wed, 25 Jul 2007 21:20:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
cc: linux-kernel@vger.kernel.org, Egmont Koblinger <egmont@uhulinux.hu>
Subject: Re: console UTF-8 fixes
In-Reply-To: <20070724214736.GL3700@interface.famille.thibault.fr>
Message-ID: <Pine.LNX.4.64.0707252118500.13337@fbirervta.pbzchgretzou.qr>
References: <20070724214736.GL3700@interface.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-1787425102-1185391216=:13337"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-1787425102-1185391216=:13337
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Jul 24 2007 23:47, Samuel Thibault wrote:
>
>Egmont got some UTF-8 fixes in mainline, Andrew Morton suggested it
>might be a good time to remember about bug 7746 Support for unicode dead
>keys: http://bugzilla.kernel.org/show_bug.cgi?id=7746 :
>
>« Quoting a mail from Vojtech Pavlik:
>
>"Several languages (polish, czech, slovak, ...) use dead keys (keys that
>don't do anything per se, but put an accent on the next letter). And
>now almost everyone is switching to unicode. And Linux kernel doesn't
>support unicode for dead keys. This means trouble."
>(full mail at
>http://www.ussg.iu.edu/hypermail/linux/kernel/0405.3/1387.html)

That got merged AFAICS...
759448f459234bfcf34b82471f0dba77a9aca498

please check :)


	Jan
-- 
---699020219-1787425102-1185391216=:13337--
