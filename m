Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbYI1UEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbYI1UEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 16:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYI1UEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 16:04:13 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:38686 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566AbYI1UEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 16:04:12 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: sdhci: Loads of scary messages during suspend/resume with SD card inserted
Date: Sun, 28 Sep 2008 22:04:07 +0200
User-Agent: KMail/1.9.9
Cc: drzeus-mmc@drzeus.cx, linux-pm@lists.linux-foundation.org
References: <200809282146.57960.elendil@planet.nl>
In-Reply-To: <200809282146.57960.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809282204.07696.elendil@planet.nl>
X-OriginalArrivalTime: 28 Sep 2008 20:04:10.0411 (UTC) FILETIME=[5F02CFB0:01C921A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 September 2008, Frans Pop wrote:
> Whilst playing with it, I found the following messages in my logs
> during suspend. At the time the card was inserted, but nothing on it
> was mounted.
>
> There also seems to be a problem while resuming, especially:
> mmc mmc0:8879: parent mmc0 should not be sleeping
> More context at the bottom of the mail.

Forgot the most important bits.

Kernel is current git (2.6.27-rc7-106-g6ef190c), x86_64.
Laptop is running Debian amd64/unstable.
