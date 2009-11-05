Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbZKETEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbZKETEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbZKETEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:04:04 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:45046 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904AbZKETEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:04:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ttg/wf5N4uuLptKpfGO7xQ6/d9C0azGP5topG6ZH0oG+o5+2A7oHvId9EfuIFp5xUo
         DlYXBx6q8ecN5H1S/MaVTyR6cCzRa4NGBgkERVp9LlfgUi0TuE8naQ86OKNgA8TqxNzW
         Zv9XzKA0locBFsoCcaZA75jK6zQx1cq0x5gh4=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 32/41] rt2800: fix duplication in header files
Date: Thu, 5 Nov 2009 20:04:04 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173554.28463.72619.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173554.28463.72619.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911052004.04666.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800: fix duplication in header files
> 
> Updated debugging scripts are located here:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/bart/rt2800/scripts/
> 
> (they also work fine with older drivers)
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

