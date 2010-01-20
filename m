Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494Ab0ATU2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0ATU2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476Ab0ATU2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:28:16 -0500
Received: from senator.holtmann.net ([87.106.208.187]:47594 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab0ATU2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:28:15 -0500
Subject: Re: [PATCH] Bluetooth: Add DFU driver for Atheros Bluetooth
 chipset AR3011
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: torvalds@linux-foundation.org, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org, mcgrof@gmail.com,
       Vikram Kandukuri <vkandukuri@atheros.com>,
       Vikram Kandukuri <vikram.kandukuri@atheros.com>,
       Alicke Xu <sxu@atheros.com>, David Miller <davem@davemloft.net>
In-Reply-To: <1264017679-19324-1-git-send-email-lrodriguez@atheros.com>
References: <1264017679-19324-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 12:27:48 -0800
Message-ID: <1264019268.5591.223.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> Signed-off-by: Vikram Kandukuri <vikram.kandukuri@atheros.com>
> Signed-off-by: Alicke Xu <sxu@atheros.com>
> Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> ---
> 
> Linus, this was merged into linux-next already. The driver is small enough,
> it just uploads firmware, I figured it would likely be welcomed into 2.6.33-rc5.
> The patch is the same as it went into linux-next. The firmware is already
> merged as part of the linux-firmware git tree.

what is going on here? Overstepping myself and also Dave for merging a
new driver at this point of time in the development cycle.

The driver is small and self-contained, I agree on that. But remember
the reason why it was not part of 2.6.33-rc1. You guys actually screwed
up the submission. And I didn't get any fixes for 1.5 month. Now you are
pushing it like this?

Dave, I have no objection to merging this. So if you are happy in taking
in it this late, I include it in the round of fixes that I am putting
together.

Regards

Marcel


