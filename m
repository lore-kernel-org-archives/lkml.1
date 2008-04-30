Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbYD3LAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbYD3LAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbYD3LAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:00:05 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:46034 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbYD3LAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:00:04 -0400
Subject: Re: [PATCH -next 2/2] sysfs: sysfs_update_group stub for
	CONFIG_SYSFS=n
From: "Denis V. Lunev" <den@openvz.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       jejb <James.Bottomley@HansenPartnership.com>, gregkh <greg@kroah.com>,
       akpm <akpm@linux-foundation.org>, sfr@canb.auug.org.au
In-Reply-To: <20080423095622.25e29f45.randy.dunlap@oracle.com>
References: <20080423095622.25e29f45.randy.dunlap@oracle.com>
Content-Type: text/plain
Organization: OpenVz kernel team
Date: Wed, 30 Apr 2008 14:58:21 +0400
Message-Id: <1209553101.7357.2.camel@iris.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 09:56 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> scsi_transport_spi uses sysfs_update_group() when CONFIG_SYSFS=n,
> so provide a stub for it.
> 
> next-20080423/drivers/scsi/scsi_transport_spi.c:1467: error: implicit declaration of function 'sysfs_update_group'
> make[3]: *** [drivers/scsi/scsi_transport_spi.o] Error 1
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

This patch seems lost. Current Linus GIT tree is still affected.

Regards,
	Den

