Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbXA2VpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbXA2VpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 16:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbXA2VpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 16:45:22 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54848 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbXA2VpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 16:45:20 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <1170106290.1296.22.camel@localhost>
References: <20070123211159.178138000@localhost.localdomain>
	 <20070127181759.eb7fe5e8.akpm@osdl.org>
	 <1170106290.1296.22.camel@localhost>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 13:45:15 -0800
Message-Id: <1170107115.1296.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 13:31 -0800, john stultz wrote:
> Should I just revive the old 2.6.20-rc4-mm1 patches against your current
> tree and re-submit? Or should the HRT bits get settled first?

Thomas just pointed out that I had missed that the bits are back in
-mm2.

Sorry for the noise.
-john


