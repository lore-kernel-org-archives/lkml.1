Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbZIGKPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbZIGKPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 06:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZIGKPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 06:15:22 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:54515 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZIGKPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 06:15:22 -0400
Subject: Re: [PATCH] regulator: update a filename in documentation
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1252265183-7626-1-git-send-email-w.sang@pengutronix.de>
References: <1252265183-7626-1-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 11:15:22 +0100
Message-Id: <1252318522.5876.1.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 21:26 +0200, Wolfram Sang wrote:
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  Documentation/power/regulator/overview.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/power/regulator/overview.txt b/Documentation/power/regulator/overview.txt
> index 0cded69..b471575 100644
> --- a/Documentation/power/regulator/overview.txt
> +++ b/Documentation/power/regulator/overview.txt
> @@ -168,4 +168,4 @@ relevant to non SoC devices and is split into the following four interfaces:-
>        userspace via sysfs. This could be used to help monitor device power
>        consumption and status.
>  
> -        See Documentation/ABI/testing/regulator-sysfs.txt
> +        See Documentation/ABI/testing/sysfs-class-regulator

Applied.

Thanks

Liam

