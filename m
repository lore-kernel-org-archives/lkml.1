Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbYIQRBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbYIQRBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 13:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbYIQQ7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:59:34 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:52483 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbYIQQ7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=CT7/CEc0+YHrPl9Zkgg6QJtXmoV1ZbNP5vVWmanITZDTB5ypTyoLiOkMow7sVYrqx8
         qor459DPuAirR5jwNyyT142JRqCe145rsXRnQqyJTTSjPghjFkck4LbTnuPAEAI5y8FN
         56FYuV5cWCTL2tsgPr0TyNI9mVahjEsmSE8OI=
Message-ID: <48D13712.1090904@gmail.com>
Date: Wed, 17 Sep 2008 09:57:54 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4 v2] Introduce ata_id_has_unload()
References: <87d4j2n3dn.fsf@denkblock.local> <20080917163144.9870.90985.stgit@denkblock.local>
In-Reply-To: <20080917163144.9870.90985.stgit@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
> Add a function to check an ATA device's id for head unload support as
> specified in ATA-7.
> 
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
