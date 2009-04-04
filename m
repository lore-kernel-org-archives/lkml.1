Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZDDXiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZDDXiJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 19:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZDDXhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 19:37:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42983
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754195AbZDDXhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 19:37:53 -0400
Date: Sat, 04 Apr 2009 16:37:42 -0700 (PDT)
Message-Id: <20090404.163742.02838692.davem@davemloft.net>
To: jaswinder@kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] [SCSI] qlogicpti: use request_firmware
From: David Miller <davem@davemloft.net>
In-Reply-To: <1238703170.3099.90.camel@ht.satnam>
References: <1238703170.3099.90.camel@ht.satnam>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date: Fri, 03 Apr 2009 01:42:50 +0530

> Firmware blob is little endian
> 
> Thanks to Stephen Rothwell for fixing typos
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

This looks fine to me.
