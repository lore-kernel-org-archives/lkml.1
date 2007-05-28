Return-Path: <linux-kernel-owner+w=401wt.eu-S1760292AbXE1CvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbXE1CvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 22:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbXE1CvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 22:51:17 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:49186 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbXE1CvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 22:51:16 -0400
Date: Sun, 27 May 2007 19:44:10 -0700
From: Jouni Malinen <j@w1.fi>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, hostap@shmoo.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] use list_for_each_entry() for iteration in hostap_ap.c
Message-ID: <20070528024409.GV5416@jm.kir.nu>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Christoph Hellwig <hch@infradead.org>, hostap@shmoo.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070525125630.GE31790@traven> <20070525130308.GF31790@traven> <20070525143005.GB10669@infradead.org> <20070527102824.GJ31790@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070527102824.GJ31790@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 12:28:24PM +0200, Matthias Kaehlcke wrote:

> thanks for your comment, here's a patch that uses
> list_for_each_entry(), additionally to the initial patch it
> substitutes some list_for_each() loops by list_for_each_entry()

Thanks! I added this to my list of patches for the driver.

Could you please send a Signed-off-by line for this later version of the
patch? You did it for the first version, but just to be sure, it would
be prefered to see this explicitly for each version.

-- 
Jouni Malinen                                            PGP id EFC895FA
