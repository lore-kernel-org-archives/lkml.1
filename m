Return-Path: <linux-kernel-owner+w=401wt.eu-S936333AbXFFWP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936333AbXFFWP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934830AbXFFWPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:15:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53710 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934501AbXFFWPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:15:10 -0400
Subject: Re: 2.6.22-rc4-mm1
From: Kay Sievers <kay.sievers@vrfy.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <4667018D.7020407@googlemail.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	 <4667018D.7020407@googlemail.com>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 00:14:55 +0200
Message-Id: <1181168095.3612.4.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/B/toiJ3VkAtghmXLPPr0OgHgiyIhKIP0zQ27
 wrfvw74Uyw9QNWBc6QssLisFJVwcnDdIbHkfHQPQM0yKjBrkug
 3zs4yQ4YdZml6VYjlPQvJprd3wyh0jS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 20:48 +0200, Michal Piotrowski wrote:
> Andrew Morton pisze:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
> > 
> 
> Kay, your patch gregkh-driver-block-device.patch breaks Fedora 7 initrd
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/initrd.jpg
> 
> Please fix it ASAP, I can't test kernel...

Do you have CONFIG_SYSFS_DEPRECATED set or unset?

Kay

