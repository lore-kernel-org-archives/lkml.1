Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbXDMJFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbXDMJFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 05:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXDMJFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 05:05:24 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:4904 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753100AbXDMJFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 05:05:23 -0400
Date: Fri, 13 Apr 2007 11:04:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org, akpm@osdl.org
Subject: Re: [PATCH 10/30 #2] Use menuconfig objects - I2C
Message-ID: <20070413110413.3316e32e@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.61.0704111425520.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704102310310.32056@yvahk01.tjqt.qr>
	<20070411101412.6c5512e7@hyperion.delvare>
	<Pine.LNX.4.61.0704111024090.32056@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704111425520.32056@yvahk01.tjqt.qr>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 14:28:30 +0200 (MEST), Jan Engelhardt wrote:
> Allow the whole I2C menu to be disabled at once without diving into
> the submenus for deselecting all options (should the user desire so).
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
>  Kconfig        |   15 ++-------
>  algos/Kconfig  |    8 +---
>  busses/Kconfig |   93 +++++++++++++++++++++++++++------------------------------
>  chips/Kconfig  |   23 ++++++--------
>  4 files changed, 62 insertions(+), 77 deletions(-)

Applied, thanks.

-- 
Jean Delvare
