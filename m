Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbYILWk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbYILWk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbYILWkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:40:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37250 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbYILWkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:40:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Miller <davem@davemloft.net>
X-Fcc: ~/Mail/linus
Cc: rmk+lkml@arm.linux.org.uk, linux-arch@vger.kernel.org,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HAVE_ARCH_TRACEHOOK and you
In-Reply-To: David Miller's message of  Friday, 12 September 2008 15:37:03 -0700 <20080912.153703.21849753.davem@davemloft.net>
References: <20080912025733.E55F415420D@magilla.localdomain>
	<20080912131351.GA31545@flint.arm.linux.org.uk>
	<20080912223156.51D4815420D@magilla.localdomain>
	<20080912.153703.21849753.davem@davemloft.net>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080912223926.5EF0715420D@magilla.localdomain>
Date: Fri, 12 Sep 2008 15:39:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It was allocating too much memory, which is harmless.

Didn't it also write NT_PRFPREG notes of the wrong size?


Thanks,
Roland
