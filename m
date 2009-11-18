Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbZKRSid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbZKRSid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZKRSic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:38:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49230
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754738AbZKRSic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:38:32 -0500
Date: Wed, 18 Nov 2009 10:38:48 -0800 (PST)
Message-Id: <20091118.103848.39318908.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: sshtylyov@ru.mvista.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hpt366: remove dead old timing tables
From: David Miller <davem@davemloft.net>
In-Reply-To: <200911181932.07651.bzolnier@gmail.com>
References: <200911181932.07651.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Wed, 18 Nov 2009 19:32:07 +0100

> It has been enough time since introduction of the new timing tables
> (commit 809b53c from Dec 12 2007) and the old timing tables are still
> available in pata_hpt37x.c (or git history) if somebody needs them.
> 
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied to ide-next-2.6, thanks.
