Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbZLNUKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbZLNUKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZLNUKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:10:08 -0500
Received: from relay.atmel.no ([80.232.32.139]:60965 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757764AbZLNUKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:10:07 -0500
X-Greylist: delayed 2056 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Dec 2009 15:10:06 EST
Date: Mon, 14 Dec 2009 20:35:42 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "H Hartley Sweeten" <hartleys@visionengravers.com>
Cc: "kernel list" <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
       "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
Subject: Re: [PATCH] atmel-mci.c: use resource size()
Message-ID: <20091214203542.31f7a179@hskinnemoen-d830>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200E9EA@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090200E9EA@mi8nycmail19.Mi8.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H Hartley Sweeten" <hartleys@visionengravers.com> wrote:
> Use resource_size().
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
