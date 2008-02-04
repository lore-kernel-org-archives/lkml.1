Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYBDWAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYBDWAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYBDWAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:00:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:47456 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216AbYBDWAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:00:24 -0500
Subject: Re: tg3 broken after "PCI: Fix bus resource assignment on 32 bits
	with 64b resources"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080204151222.GB25790@localhost.sw.ru>
References: <20080204151222.GB25790@localhost.sw.ru>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 08:59:41 +1100
Message-Id: <1202162381.7079.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And I could also use the lspci output without the patch.

Thanks,
Ben.


