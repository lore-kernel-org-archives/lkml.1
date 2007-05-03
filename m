Return-Path: <linux-kernel-owner+w=401wt.eu-S1162181AbXECQ5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162181AbXECQ5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162183AbXECQ5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:57:54 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:4217 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1162181AbXECQ5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:57:53 -0400
Date: Thu, 3 May 2007 18:58:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 08/36] Use menuconfig objects II - hwmon
Message-ID: <20070503185850.5db788e4@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.61.0704301327500.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704301327500.29151@yvahk01.tjqt.qr>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Mon, 30 Apr 2007 13:28:29 +0200 (MEST), Jan Engelhardt wrote:
> 
> Change Kconfig objects from "menu, config" into "menuconfig" so
> that the user can disable the whole feature without having to
> enter the menu first.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
> ---
>  drivers/hwmon/Kconfig |  109 ++++++++++++++++++++++++--------------------------
>  1 file changed, 53 insertions(+), 56 deletions(-)

Applied, thanks.

-- 
Jean Delvare
