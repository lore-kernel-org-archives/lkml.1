Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbZKESo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbZKESo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758358AbZKESo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:44:57 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:56311 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335AbZKESo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:44:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=JwAq85ZSSjIgrLF0CElIxAHpL6T4hhkIso2PbDSiwMTo+K+3GhiAh3lPrErMUuc/M/
         ybQf7lbM2nOii2M/r0ZohdN4Eew6/LkSuKU2Z4knIuRE2+rM2ABU/wUGysAoA0MOw66W
         NxHv4qwfjr8GtrOiFMwf0Ug14Am82UXEjEx5U=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 09/41] rt2800usb: add rt2800_register_[read,write]() wrappers
Date: Thu, 5 Nov 2009 19:44:58 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173305.28463.69600.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173305.28463.69600.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051944.59258.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: add rt2800_register_[read,write]() wrappers
> 
> Part of preparations for later code unification.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

