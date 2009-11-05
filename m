Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZKESww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZKESww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758255AbZKESwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:52:51 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:49983 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758569AbZKESwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:52:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=eY8XM+bYDzbxSXqn0lRadQD9l8Xie6XppA4NnNNGuc4fFO4Gj061q2YFcdXQWEbv5S
         1XuS2JjY3pea1pRpSKKWbq62J6lJ0F3NJxJGGiJ0mDIuEi8pNZoyGahoaKdyAC9t0BRW
         eyrx+gzZ0+AaFlrlbp7JO0nFs0H0X8NOtqufk=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 23/41] rt2x00: add driver private field to struct rt2x00_dev
Date: Thu, 5 Nov 2009 19:52:50 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173446.28463.62662.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173446.28463.62662.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051952.51189.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: add driver private field to struct rt2x00_dev
> 
> Enhance rt2x00 infrastructure by adding driver specific field to
> struct rt2x00_dev.
> 
> The new field will be used by rt2800 drivers for chipset registers
> access abstraction layer.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
