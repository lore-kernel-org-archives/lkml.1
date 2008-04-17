Return-Path: <linux-kernel-owner+w=401wt.eu-S934465AbYDQLRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465AbYDQLRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYDQLRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:17:00 -0400
Received: from eazy.amigager.de ([213.239.192.238]:44708 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYDQLQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:16:59 -0400
Date: Thu, 17 Apr 2008 13:16:56 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 regression: 60417f5976df breaks Thinkpad suspend
Message-ID: <20080417111656.GA3602@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080415115326.9915.qmail@science.horizon.com> <200804161937.25557.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804161937.25557.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 19:37:24 +0200, Rafael J. Wysocki wrote:

[...]

> This change has been reverted from the current Linus' tree, so please check
> if 2.6.25-rc9 (or a later git snapshot) works for you.

I tried suspend to RAM with the final 2.6.25 on a T20 (which should be
very similar) and it worked fine. I could recheck with an affected rc
to verify that it was broken before.

Regards,
Tino
