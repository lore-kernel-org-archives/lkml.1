Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYIAIrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYIAIrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 04:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYIAIrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 04:47:43 -0400
Received: from s200aog13.obsmtp.com ([207.126.144.127]:47677 "EHLO
	s200aog13.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbYIAIrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 04:47:43 -0400
Subject: Re: [PATCH] genirq: irq_chip->startup() usage in setup_irq and
	set_irq_chained handler
From: Pawel MOLL <pawel.moll@st.com>
To: benh@kernel.crashing.org
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1219795619.13162.166.camel@pasglop>
References: <1219313656.31630.89.camel@bri1004.bri.st.com>
	 <1219416584.31630.639.camel@bri1004.bri.st.com>
	 <20080823160859.GE27974@elte.hu>  <1219531395.21386.200.camel@pasglop>
	 <1219745676.16078.219.camel@bri1004.bri.st.com>
	 <1219795619.13162.166.camel@pasglop>
Content-Type: text/plain; charset=utf-8
Date: Mon, 01 Sep 2008 09:47:18 +0100
Message-Id: <1220258838.3299.1107.camel@bri1004.bri.st.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Great, thanks ;-)

Ingo, I will send you an acked patch.

Cheers

Paweł

