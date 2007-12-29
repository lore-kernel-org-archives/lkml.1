Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbXL2IyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbXL2IyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 03:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbXL2IyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 03:54:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50167
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751947AbXL2IyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 03:54:10 -0500
Date: Sat, 29 Dec 2007 00:54:08 -0800 (PST)
Message-Id: <20071229.005408.76652528.davem@davemloft.net>
To: bunk@kernel.org
Cc: errandir_news@mph.eclipse.co.uk, m.kozlowski@tuxland.pl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1: some section mismatches on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071229084846.GA27360@does.not.exist>
References: <20071228232255.GB9105@does.not.exist>
	<20071229.001411.210630819.davem@davemloft.net>
	<20071229084846.GA27360@does.not.exist>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sat, 29 Dec 2007 10:48:46 +0200

> On Sat, Dec 29, 2007 at 12:14:11AM -0800, David Miller wrote:
> > That's why I'm not worried about this issue and it's not critical at
> > all.
> 
> If a module calls sunserial_console_match() that's an Oops.

That's true.

I'm trying to figure out a way to fix this.
