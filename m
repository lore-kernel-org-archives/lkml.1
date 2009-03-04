Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZCDP3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZCDP3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 10:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbZCDP3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 10:29:09 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:21548 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZCDP3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 10:29:08 -0500
Date: Wed, 4 Mar 2009 16:28:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: djwong@us.ibm.com, linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] lm90: Support the MAX6648/6692 chips
Message-ID: <20090304162858.658cb2d9@hyperion.delvare>
In-Reply-To: <20090302150742.0894eaad.akpm@linux-foundation.org>
References: <20090302210106.GD6550@plum>
	<20090302150742.0894eaad.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, 2 Mar 2009 15:07:42 -0800, Andrew Morton wrote:
> These three patches look like 2.6.29 material to me.  If none of
> them pop up in linux-next I'll plan to merge them a few days from now.

As the lm90 driver maintainer, I will take care of the lm90 patch. Feel
free to handle the lm85 patches if you want.

Thanks,
-- 
Jean Delvare
