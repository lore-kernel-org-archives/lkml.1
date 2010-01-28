Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079Ab0A1TQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab0A1TQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 14:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869Ab0A1TQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 14:16:40 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59448 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab0A1TQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 14:16:40 -0500
Subject: Re: [PATCH] regulator: Convert fixed voltage regulator to use
 enable_time()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1264674065-21852-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1264674065-21852-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 19:16:35 +0000
Message-ID: <1264706195.3044.251.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 10:21 +0000, Mark Brown wrote:
> It had an open coded version in enable().
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/fixed.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 

Applied.

Thanks

Liam

