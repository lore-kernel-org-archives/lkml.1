Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZLHHer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZLHHer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZLHHeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:34:46 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35617 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbZLHHep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:34:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=JKWywRXUaYGSyMmbHPVUO6Yo4g0/WgwGcJQMk0C1buvRxzrVxcQbDp/Yzgjsgi+98H
         Tc+0GYeKbYwwLwAKwUd6hQUgwn9JubKwgnbIl7kNSf29BdLEvrnHNZF4NRqSrwc09pHj
         ojjDZUFv3qbrcgn4aO2cGkZtGhX5s8NE/Wi2o=
Subject: Re: [PATCH v8 8/8] Loongson: YeeLoong: add input/hotkey driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20091208072347.GH11147@core.coreip.homeip.net>
References: <cover.1260082252.git.wuzhangjin@gmail.com>
	 <b164d5bb79963a57621d024c22e5664de0ff8662.1260082252.git.wuzhangjin@gmail.com>
	 <20091207064857.GG21451@core.coreip.homeip.net>
	 <1260255131.3315.25.camel@falcon.domain.org>
	 <20091208072347.GH11147@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Tue, 08 Dec 2009 15:34:18 +0800
Message-ID: <1260257658.3315.74.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 23:23 -0800, Dmitry Torokhov wrote:
> On Tue, Dec 08, 2009 at 02:52:11PM +0800, Wu Zhangjin wrote:
> > Hi, Dmitry Torokhov
> > 
> > I plan to send another revision of this patchset, Can I get your
> > Acked-by: for this patch?
> > 
> 
> Yes, as far as the input code goes:
> 
> 	Acked-by: Dmitry Torokhov <dtor@mail.ru>

Added, thanks!

To Ralf:

This patch is based on the sparse keymap library in:

git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input next

from Dmitry Torokhov. that sparse keymap support is also queued for
2.6.33.

Before that support going into mainline, this patch can not be compiled,
so, Ralf, this patch is not appliable before Dmitry's next branch is
pulled by linus.

Thanks!
	Wu Zhangjin

