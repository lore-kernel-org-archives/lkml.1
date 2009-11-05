Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZKETK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZKETK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbZKETK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:10:28 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:44492 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577AbZKETK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:10:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=EGvjuug3rF3gl4mlJPuKagtF8GEPjphlzweKke1n5zCKefSUKRdWhH45qYExocNj4l
         K5yebbfa1d1Rj2iUKSjTpm0mjXC+OYEXUaIHdo4w+4GMjkTHElCzqU14OJg5G9OXxyXA
         nAR/UCtpOCs6rOcVnudu85J0Bqag2+cbhhcPA=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 39/41] rt2x00: move REGISTER_BUSY_* definitions to rt2x00.h
Date: Thu, 5 Nov 2009 20:10:28 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173650.28463.23162.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173650.28463.23162.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911052010.29318.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: move REGISTER_BUSY_* definitions to rt2x00.h
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

