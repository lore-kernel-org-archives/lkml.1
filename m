Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbXHTSyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbXHTSyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 14:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXHTSyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 14:54:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbXHTSyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 14:54:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do_sigaction: don't worry about signal_pending()
In-Reply-To: Oleg Nesterov's message of  Monday, 20 August 2007 20:01:57 +0400 <20070820160157.GA1279@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20070820185358.881064D05C6@magilla.localdomain>
Date: Mon, 20 Aug 2007 11:53:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I agree, I don't think this check is buying us anything now.


Thanks,
Roland
