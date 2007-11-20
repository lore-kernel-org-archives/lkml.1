Return-Path: <linux-kernel-owner+w=401wt.eu-S1761508AbXKTTwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761508AbXKTTwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 14:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbXKTTv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 14:51:57 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:54099 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756780AbXKTTv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 14:51:57 -0500
Date: Tue, 20 Nov 2007 20:51:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: Re: [PATCH 16/59] drivers/i2c: Add missing "space"
Message-ID: <20071120205155.32a79a20@hyperion.delvare>
In-Reply-To: <1195523331-15303-17-git-send-email-joe@perches.com>
References: <1195523331-15303-1-git-send-email-joe@perches.com>
	<1195523331-15303-2-git-send-email-joe@perches.com>
	<1195523331-15303-3-git-send-email-joe@perches.com>
	<1195523331-15303-4-git-send-email-joe@perches.com>
	<1195523331-15303-5-git-send-email-joe@perches.com>
	<1195523331-15303-6-git-send-email-joe@perches.com>
	<1195523331-15303-7-git-send-email-joe@perches.com>
	<1195523331-15303-8-git-send-email-joe@perches.com>
	<1195523331-15303-9-git-send-email-joe@perches.com>
	<1195523331-15303-10-git-send-email-joe@perches.com>
	<1195523331-15303-11-git-send-email-joe@perches.com>
	<1195523331-15303-12-git-send-email-joe@perches.com>
	<1195523331-15303-13-git-send-email-joe@perches.com>
	<1195523331-15303-14-git-send-email-joe@perches.com>
	<1195523331-15303-15-git-send-email-joe@perches.com>
	<1195523331-15303-16-git-send-email-joe@perches.com>
	<1195523331-15303-17-git-send-email-joe@perches.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Mon, 19 Nov 2007 17:48:08 -0800, Joe Perches wrote:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/i2c/busses/i2c-davinci.c |    4 ++--
>  drivers/i2c/busses/i2c-omap.c    |    6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
> (...)

Good catch. Patch applied, thanks.

-- 
Jean Delvare
