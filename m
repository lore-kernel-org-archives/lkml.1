Return-Path: <linux-kernel-owner+w=401wt.eu-S936871AbXGMJr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936871AbXGMJr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935867AbXGMJrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:47:12 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:2238 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935567AbXGMJrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:47:10 -0400
Date: Fri, 13 Jul 2007 11:47:41 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] w1_ds2760: Fix binary file read callback signature
Message-ID: <20070713114741.6f510063@hyperion.delvare>
In-Reply-To: <20070713093851.GA11658@2ka.mipt.ru>
References: <20070713112643.6a6daf73@hyperion.delvare>
	<20070713093851.GA11658@2ka.mipt.ru>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

On Fri, 13 Jul 2007 13:38:51 +0400, Evgeniy Polyakov wrote:
> On Fri, Jul 13, 2007 at 11:26:43AM +0200, Jean Delvare (khali@linux-fr.org) wrote:
> > Commit 91a6902958f052358899f58683d44e36228d85c2 changed the binary
> > sysfs file signatures at the same time the w1_ds2760 driver was added.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> 
> I have no problem with this patch. Should I forward it to Andrew or you
> will pick this up?

Please forward it to Andrew.

Thanks,
-- 
Jean Delvare
