Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbZFKHZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbZFKHZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 03:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbZFKHZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 03:25:02 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:50289 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbZFKHZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 03:25:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=fg98AuoMXtWRDf1CtUKQ/037BD/Gg7U4s0NueSPwbQmaM9mOAO6V88Uddfc0CSWpVB
         QcCYo6koAzQkeEFiPkLd3fsh+vIV5VveW6k2yOwYnZbzopYdXQdX+amR1doNJBMg1siw
         ZfFut7Y0Aoj3iBBNxmamZpnOlmRVIb8US5xRk=
To: Bob Copeland <me@bobcopeland.com>
Cc: Brian Swetland <swetland@google.com>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       ibm@android.com, san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
References: <20090610103131.GB13885@elf.ucw.cz>
	<a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com>
	<b6c5339f0906101247jff9297ehbf26a6c2dd6e2d87@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 11 Jun 2009 10:24:51 +0300
In-Reply-To: <b6c5339f0906101247jff9297ehbf26a6c2dd6e2d87@mail.gmail.com> (Bob Copeland's message of "Wed\, 10 Jun 2009 15\:47\:03 -0400")
Message-ID: <87my8f9qrg.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Copeland <me@bobcopeland.com> writes:

> On Wed, Jun 10, 2009 at 1:43 PM, Brian Swetland<swetland@google.com> wrote:
>> The ti wifi driver is enormous and in its own repository:
>> http://android.git.kernel.org/?p=platform/system/wlan/ti.git;a=shortlog;h=refs/heads/cupcake
>
> For wifi, there's a patch to add sdio support to the soon-to-be-upstream
> wl12xx.  It works, but that's about all for now.  Patch is at
> http://bobcopeland.com/android_wifi.html, though the linux-wireless list
> is the official location for any future discussion / updates.

wl12xx is in net-next-2.6 tree currently and it should go to 2.6.31:

http://git.kernel.org/?p=linux/kernel/git/davem/net-next-2.6.git;a=tree;f=drivers/net/wireless/wl12xx;h=06a34fea0223c161c7b21a6bc226b5882dcd39c8;hb=HEAD

-- 
Kalle Valo
