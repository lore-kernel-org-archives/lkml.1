Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884Ab0ADUfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0ADUfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 15:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420Ab0ADUfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 15:35:46 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39548 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab0ADUfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 15:35:45 -0500
Subject: Re: [PATCH 0/3] Regulator updates for 2.6.34
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100104181634.GA18258@rakim.wolfsonmicro.main>
References: <20100104181634.GA18258@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 20:35:38 +0000
Message-ID: <1262637338.2968.36.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 18:16 +0000, Mark Brown wrote:
> The following changes since commit 204f78ec75e6888bbf1a7b5a3ed0cbfff9bade27:
>   Tobias Klauser (1):
>         regulator/lp3971: Storage class should be before const qualifier
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator-2.6.git for-lrg
> 
> A couple of new APIs, plus a use of one of them.
> 
> Mark Brown (3):
>       regulator: Add notifier event on regulator disable
>       regulator: Allow regulators to specify the time taken to ramp on enable
>       regulator: Implement enable_time() for WM835x ISINKs
> 
>  drivers/regulator/core.c             |   48 ++++++++++++++++++++++++++++-----
>  drivers/regulator/wm8350-regulator.c |   46 ++++++++++++++++++++++++++++++++
>  include/linux/regulator/consumer.h   |    4 ++-
>  include/linux/regulator/driver.h     |    6 ++++
>  4 files changed, 95 insertions(+), 9 deletions(-)
> --

Pulled.

Thanks

Liam

