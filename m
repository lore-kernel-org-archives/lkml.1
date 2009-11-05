Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbZKETGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbZKETGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbZKETGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:06:24 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46308 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896AbZKETGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:06:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=lJLsK9CsQP/avXOdGfuYQLTNt7R2aHX4jJERNov+V9xJa0ASX8SaCQm1bUafwj22lH
         bTyltmvfWvy0pIG+rmJYsoy4mvznbRUwbDgkMRjj8dn5prm4dcSyX4LE5+whFxB0FoT9
         2dux3QmiJyFaLh0g5AthcoclgZxGp9/hWdqmA=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 34/41] rt2x00: add support for different chipset interfaces
Date: Thu, 5 Nov 2009 20:06:25 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173610.28463.4270.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173610.28463.4270.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911052006.25669.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: add support for different chipset interfaces
> 
> Enhance rt2x00 infrastructure by adding explicit information
> about used chipset interface to struct rt2x00_chip.
> 
> The new field will be used by rt2800 drivers for rt2800 library.
> 
> Also add commonly used rt2x00_intf_is_pci() and rt2x00_intf_is_usb()
> helpers to make code easier to read (noticed by Ivo van Doorn).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
