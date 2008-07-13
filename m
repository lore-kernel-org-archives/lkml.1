Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYGMSsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYGMSsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYGMSsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:48:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38764 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYGMSsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:48:30 -0400
Message-ID: <487A4DFC.5090701@firstfloor.org>
Date: Sun, 13 Jul 2008 20:48:28 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
References: <200807080141.05436.yhlu.kernel@gmail.com>	 <200807080143.27997.yhlu.kernel@gmail.com>	 <200807092015.03004.yhlu.kernel@gmail.com>	 <20080710071640.5035cd70@infradead.org>	 <874p6t25n5.fsf@basil.nowhere.org> <86802c440807131117g3ba9e61chea61af81b7537bb0@mail.gmail.com>
In-Reply-To: <86802c440807131117g3ba9e61chea61af81b7537bb0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> with this patch, my 256g system still use gbpages for 1g-3g, 4g-256g

256GB certainly qualifies as "large system". But as Linus always says:
Linux is not for servers only. Ignoring the small systems makes you
look bad.

-Andi

