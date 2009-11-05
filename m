Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbZKES7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbZKES7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758362AbZKES7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:59:37 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:33853 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936AbZKES7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:59:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=GV/PxbI34SlRSlF403Z+AAktJR93t/GiZ4CyKkP9ER6YDgXpfsEinLhxFbhly96mHi
         m2B8ilD6bO62jJKfpSlQZQ0iSqYx9BWU0oeqzpO3265CCyzUE3KfCdyy7Fh5V743PAp4
         1ec4gZUC0XH8J04rDeP4qBl7NBcoC+8pHFvU8=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 28/41] rt2x00: fix rt2x00pci_register_multi[read,write]() arguments
Date: Thu, 5 Nov 2009 19:59:38 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173525.28463.40807.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173525.28463.40807.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051959.39212.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: fix rt2x00pci_register_multi[read,write]() arguments
> 
> Change type of 'length' argument from u16 to u32 (all arguments
> match rt2x00usb_register_multi[read,write]() ones now).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>


