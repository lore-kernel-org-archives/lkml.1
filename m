Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbYBQTBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbYBQTBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYBQTBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:01:36 -0500
Received: from phoenix.slamd64.com ([217.10.145.2]:57200 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYBQTBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:01:36 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/2] x86 - Move laptop drivers out of x86 Kconfig
Date: Sun, 17 Feb 2008 19:01:17 +0000
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20080208124721.16369.76502.stgit@localhost> <20080217182008.GZ6006@elte.hu>
In-Reply-To: <20080217182008.GZ6006@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171901.17698.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sun, 17 Feb 2008 19:02:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 February 2008 18:20:08 Ingo Molnar wrote:
> i suspect this should be merged by the char driver tree which is
> affected by the addition of these new entries.

Where is such a tree, and who's responsible for it though? I grep'ed 
MAINTAINERS and didn't turn up anyone.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
