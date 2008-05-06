Return-Path: <linux-kernel-owner+w=401wt.eu-S1764669AbYEFTMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764669AbYEFTMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYEFTMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:12:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:24853 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbYEFTMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:12:05 -0400
Date: Tue, 6 May 2008 21:11:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled i2c driver removal
Message-ID: <20080506211145.752f0e3f@hyperion.delvare>
In-Reply-To: <20080505182950.GB17139@cs181133002.pp.htv.fi>
References: <20080505182950.GB17139@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 21:29:50 +0300, Adrian Bunk wrote:
> This patch contains the scheduled removal of i2c-i810, i2c-prosavage and 
> i2c-savage4.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  Documentation/feature-removal-schedule.txt |    7 
>  Documentation/i2c/busses/i2c-i810          |   47 ---
>  Documentation/i2c/busses/i2c-prosavage     |   23 -
>  Documentation/i2c/busses/i2c-savage4       |   26 -
>  drivers/i2c/busses/Kconfig                 |   52 ---
>  drivers/i2c/busses/Makefile                |    3 
>  drivers/i2c/busses/i2c-i810.c              |  260 ----------------
>  drivers/i2c/busses/i2c-prosavage.c         |  325 ---------------------
>  drivers/i2c/busses/i2c-savage4.c           |  185 -----------
>  9 files changed, 928 deletions(-)
> (...)

Applied, thanks.

-- 
Jean Delvare
