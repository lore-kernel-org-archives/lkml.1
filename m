Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZHTR1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZHTR1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 13:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZHTR1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 13:27:39 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:42534 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbZHTR1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 13:27:38 -0400
Date: Thu, 20 Aug 2009 13:27:34 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: q-funk@iki.fi
Cc: Takashi Iwai <tiwai@suse.de>, deepak@laptop.org, Tobias_Mueller@twam.info,
       linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       akpm@linux-foundation.org, cjb@laptop.org
Subject: Re: [PATCH 1/3] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver  
 support
Message-ID: <20090820132734.03127196@mycelium.queued.net>
In-Reply-To: <11fae7c70908201003x3f7bf8aga74aa7db4dbba3d2@mail.gmail.com>
References: <20090818175314.16c81ca4@mycelium.queued.net>
	<s5hd46qo6j3.wl%tiwai@suse.de>
	<20090820124002.58d3d25b@mycelium.queued.net>
	<11fae7c70908201003x3f7bf8aga74aa7db4dbba3d2@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 20:03:14 +0300
Martin-Éric Racine <q-funk@iki.fi> wrote:

>  On Thu, 20 Aug 2009 17:21:20 +0200 Takashi Iwai <tiwai@suse.de>
> wrote:
> > BTW CONFIG_GPIO_CS5536 and CONFIG_CS5536_GPIO are so confusing... :)
> 
> That's because too many people who write drivers lack a bird's eye
> view on the whole Geode platform's history and end up inventing driver
> names that only further add to the confusion.  Ages ago, on the Geode

Uh, I'm assuming he meant the GPIO_CS* vs CS*_GPIO bit.  They're both
CS5535 in Kconfig.
