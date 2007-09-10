Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbXIJTVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbXIJTVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756387AbXIJTV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:21:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:62390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbXIJTV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:21:26 -0400
Message-Id: <20070910191324.847651727@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 21:13:24 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: [patch 0/3] futex_compat fixes
X-Provags-ID: V01U2FsdGVkX18UmFX956R0DAzwUZImI4Xr9UFdZMl+265jEH+
 pYcCUtU9o9LqJjLDF7lgwRkTjCR1XvG83+/cuu2eKGoMdv1//o
 mGWaEAcActvW77cJtd6nQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After looking at the futex_compat code some more, this is what I
ended up with. Please look closely at the changes, as I have not
actually tested them, being on a 32 bit machine at the moment.

I'd suggest merging the first patch in 2.6.23 instead of the original
one from David Miller, and the other two for 2.6.24.

	Arnd <><

-- 

