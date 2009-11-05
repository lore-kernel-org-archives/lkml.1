Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbZKESu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbZKESu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758425AbZKESu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:50:57 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:32597 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316AbZKESu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:50:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=m7EeGv+7JHKnR8FCiNpC1+0lEVCiYQ03YYYTNS8+EqRYl6sRfVqYwt3gkI4IwMqybj
         P8ybDLLArgfpL6hzz6VnhYVNevIRa0Lh80Eb0lRMUlNvdCUAWT7D0MlZlyTfnMowbrYY
         nuFYX/W5TPVxLXYbY26aDXHUvY+Y21+vC7coM=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 18/41] rt2800pci: add rt2800_rfcsr_[read,write]() wrappers
Date: Thu, 5 Nov 2009 19:50:58 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173411.28463.16599.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173411.28463.16599.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051950.58662.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: add rt2800_rfcsr_[read,write]() wrappers
> 
> Part of preparations for later code unification.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

