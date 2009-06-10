Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbZFJTrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbZFJTrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761254AbZFJTrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:47:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:53534 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760899AbZFJTrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:47:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sVzjnUPXyiQ21IWJGeLdGbd2SFP9Y3kkD21hZr94HV2n3EJ8pcT58ujKrfbt4f/7Ut
         ldpexI4Ypb9BN2ZTPwGg1je7jeT8YIWC5D+vMJLKmUA20cfepK5oPDtO+gHt+xh1/9HB
         a6r5Ib3Aeejmkc9DTCf0r9Ofw+8x87LY74sWU=
MIME-Version: 1.0
In-Reply-To: <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com>
Date: Wed, 10 Jun 2009 15:47:03 -0400
X-Google-Sender-Auth: 773b513c52283bce
Message-ID: <b6c5339f0906101247jff9297ehbf26a6c2dd6e2d87@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Bob Copeland <me@bobcopeland.com>
To: Brian Swetland <swetland@google.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       ibm@android.com, san@android.com, rlove@google.com,
       Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 1:43 PM, Brian Swetland<swetland@google.com> wrote:
> The ti wifi driver is enormous and in its own repository:
> http://android.git.kernel.org/?p=platform/system/wlan/ti.git;a=shortlog;h=refs/heads/cupcake

For wifi, there's a patch to add sdio support to the soon-to-be-upstream
wl12xx.  It works, but that's about all for now.  Patch is at
http://bobcopeland.com/android_wifi.html, though the linux-wireless list
is the official location for any future discussion / updates.

-- 
Bob Copeland %% www.bobcopeland.com
