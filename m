Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab0BNMIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 07:08:22 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60562 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab0BNMIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 07:08:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject;
        b=r6qTz13SlY8W6DasVjalTJ7+ExxZOzIzAi4gRooQvWXzicvWAPnCCPogMofq5F6Q1I
         ks0CZ+LMDkVvUHV3HsOzI06p2f+5wB753FnSA4gsI2M9C7O8McE0BfOXBcjXur9bUOYo
         nkltNCZoLpxpk+1/KJ/o2gv47ZF/D617GWP8c=
Message-Id: <20100214120449.503204189@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 14 Feb 2010 13:04:49 +0100
From: Bart Hartgers <bart.hartgers@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>
Subject: [patch 0/1] [PATCH v2] sata_via: Delay on vt6420 when starting ATAPI DMA write
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

As promised, here is the updated patch to fix the vt6420 ATAPI
corruption. It applies on top of my previous patch for the vt6421 PATA
DMA fix.

Sorry for sending this as a quilt patchset of one, but it is the only
reliable way I know to send patches through gmail unharmed.

Groeten,
Bart
-- 
