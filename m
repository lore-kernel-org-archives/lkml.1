Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbZKESve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbZKESve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbZKESvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:51:32 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:32950 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617AbZKESva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:51:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=MvnpH0NRc3B69zY4rIfoYxB8AxjX0QFxnRKLIZDLP8FWVnNKcFFvnw4utkkkFRB3Ru
         13cQEk0sy61xvZMqNsy+TQctd+IxDRQoDJUP1qZefXwEnylhpTIbcaogrJqB1kHmOyS4
         f0o1BHV0hsaOkSHK54m2nbpGik+kGf1pK/r0g=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 20/41] rt2800pci: add rt2800_rf_[read,write]() wrappers
Date: Thu, 5 Nov 2009 19:51:33 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173425.28463.74288.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173425.28463.74288.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051951.34268.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: add rt2800_rf_[read,write]() wrappers
> 
> Part of preparations for later code unification.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
