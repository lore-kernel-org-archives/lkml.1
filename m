Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZJ3Ihp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZJ3Ihp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 04:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbZJ3Ihi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 04:37:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57235
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491AbZJ3Ihg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 04:37:36 -0400
Date: Fri, 30 Oct 2009 01:38:00 -0700 (PDT)
Message-Id: <20091030.013800.132652248.davem@davemloft.net>
To: Martin@lichtvoll.de
Cc: linux-kernel@vger.kernel.org, hancockrwd@gmail.com,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: update Kconfig text to mark as deprecated
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910300915.51836.Martin@lichtvoll.de>
References: <51f3faa70910291719kecb5edcp3b8812981b69acb1@mail.gmail.com>
	<20091029.173028.248393897.davem@davemloft.net>
	<200910300915.51836.Martin@lichtvoll.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Steigerwald <Martin@lichtvoll.de>
Date: Fri, 30 Oct 2009 09:15:51 +0100

> You don't need to when you used UUID or LABEL - I prefer the later cause 
> its more readable. Actually I never quite understood while one would want 
> to use dynamic things like /dev/hdd or /dev/sdb in the first place. Thats 
> for me not that much better than C: or D:. Connect your harddisks 
> differently and you are screwed.

Turns out I actually have UUID mounts, great!

Only hardcoded thing in my fstab is /dev/hdc for the cdrom.
