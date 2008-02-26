Return-Path: <linux-kernel-owner+w=401wt.eu-S1765468AbYBZVcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765468AbYBZVcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762881AbYBZVbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:31:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49884
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762629AbYBZVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:31:51 -0500
Date: Tue, 26 Feb 2008 13:32:36 -0800 (PST)
Message-Id: <20080226.133236.47872026.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.25-rc3 hangs in early boot on Sun Ultra5
From: David Miller <davem@davemloft.net>
In-Reply-To: <18371.54294.748777.976300@harpo.it.uu.se>
References: <18371.10207.58819.188510@alkaid.it.uu.se>
	<18371.54294.748777.976300@harpo.it.uu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Tue, 26 Feb 2008 09:55:50 +0100

> Minor update: rc2-git7 has the slow initial console behaviour,
> but successfully switches to the framebuffer. rc2-git8 however
> hangs in the console handover. So I'll bisect git7->git8 next.

Thanks for doing this research.
