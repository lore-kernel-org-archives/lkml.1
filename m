Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbZKESxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbZKESxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbZKESxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:53:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:20504 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbZKESxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:53:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Z6Jy4+jH4MTlyvGh/6gF05GebgHedUWGpuabu5Z52DaNIkCBatw1wBS49uNZBt38ff
         q7EsI0LyefmxPO7freB9Tnpi6PX20zqLfkbqwvETuX9CxhxT3GhYDLKGdTeLmBtWokrF
         bS/LiOtN9Dx6PWOyY1pEB1Yav7yn++y+9kWfI=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 24/41] rt2800usb: convert to use struct rt2800_ops methods
Date: Thu, 5 Nov 2009 19:53:47 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173453.28463.94062.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173453.28463.94062.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051953.47346.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: convert to use struct rt2800_ops methods
> 
> Add chipset registers access abstraction layer and prepare for later
> code unification.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
