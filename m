Return-Path: <linux-kernel-owner+w=401wt.eu-S1762464AbXHOINv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762464AbXHOINv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbXHOINT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:13:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54389 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbXHOINQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:13:16 -0400
Message-ID: <46C2B59A.6070200@garzik.org>
Date: Wed, 15 Aug 2007 04:13:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: James.Bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] scsi: expose AN support to user space
References: <20070808190613.616085010@localhost.localdomain> <20070808120822.9cf187bb.kristen.c.accardi@intel.com>
In-Reply-To: <20070808120822.9cf187bb.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> If a scsi_device supports async notification for media change, then
> let user space know this capability exists by creating a new sysfs
> entry "media_change_notify", which will be 1 if it is supported, and
> 0 if not supported.  Create a routine which allows scsi devices to
> send a uevent when media change events occur.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

if James is happy with this patch, I'm happy with patch #2 and #3


