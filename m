Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbYLYPpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbYLYPpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 10:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYLYPpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 10:45:24 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:54259 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751938AbYLYPpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 10:45:23 -0500
Date: Thu, 25 Dec 2008 18:45:21 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [PATCH V2 5/7] power_supply: PCF50633 battery charger driver
Message-ID: <20081225154521.GA23659@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081218055618.31696.65002.stgit@cff.thadambail> <20081218055744.31696.14523.stgit@cff.thadambail>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081218055744.31696.14523.stgit@cff.thadambail>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 11:27:45AM +0530, Balaji Rao wrote:
> Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> Cc: Andy Green <andy@openmoko.com>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> ---

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

(As the patch depends on MFD parts, I assume Samuel will merge it
into linux-mfd.)

>  drivers/power/Kconfig            |    6 +
>  drivers/power/Makefile           |    2 
>  drivers/power/pcf50633-charger.c |  358 ++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/pcf50633/mbc.h |  134 ++++++++++++++
>  4 files changed, 500 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/power/pcf50633-charger.c
>  create mode 100644 include/linux/mfd/pcf50633/mbc.h
[...]

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
