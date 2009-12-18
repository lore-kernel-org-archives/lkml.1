Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbZLRDAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbZLRDAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 22:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZLRDAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 22:00:40 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57912 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZLRDAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 22:00:39 -0500
MIME-Version: 1.0
In-Reply-To: <1b68c6790912171645m4de68ac9i6f31346249147bd1@mail.gmail.com>
References: <fa686aa40912170840h6bd921b4me244cb83c31cab7f@mail.gmail.com> 
	<1b68c6790912171645m4de68ac9i6f31346249147bd1@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 17 Dec 2009 20:00:14 -0700
X-Google-Sender-Auth: d50e7914ca31149f
Message-ID: <fa686aa40912171900k386c748awb8d6ccb37d95285f@mail.gmail.com>
Subject: Re: [spi-devel-general] [git pull] 2nd batch of SPI changes
To: jassi brar <jassisinghbrar@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 5:45 PM, jassi brar <jassisinghbrar@gmail.com> wrote:
> On Fri, Dec 18, 2009 at 1:40 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> Jassi Brar (1):
>>      spi: Add s3c64xx SPI Controller driver
> IIRC, I didn't get any final ack of acceptance from you or any other maintainer.
> I thought perhaps the patch is lost and was preparing to resend after
> including some minor changes suggested by my ARCH maintainer(Ben Dooks).
> Though I can just as well send those changes as patches right away.
> I apologize, if i messed up.

Don't worry about it, just send an incremental patch.  I'm new to the
SPI maintainer job, and I didn't know any of the background or see any
major reason not to merge the driver, especially since it is a new
driver, and not a change to an existing one.

g.
