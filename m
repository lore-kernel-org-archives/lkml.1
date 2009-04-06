Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbZDFVMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbZDFVMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbZDFVLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:11:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:42401 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbZDFVLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:11:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=AzjXWwMlHRfA1PmOUKMakxK2s8UHJLLH9OfwgXoLGbT0McNZamHoNFKA89UmxTw3tj
         xSUetIwK/ay6N89E4sdXJvXm2r4N23/EfBnjJukuo709ZefOAmaSvLcWZj8jEqBLi92E
         rKDe9iLfBQ2vupWQV325qa5Ngm4qx6qQ589mk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] tx4939ide: Fix tx4939ide_{in,out}put_data_swap argument
Date: Mon, 6 Apr 2009 22:58:25 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1239035801-9603-1-git-send-email-anemo@mba.ocn.ne.jp>
In-Reply-To: <1239035801-9603-1-git-send-email-anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904062258.26062.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 April 2009, Atsushi Nemoto wrote:
> The commit adb1af9 ("ide: pass command instead of request to
> ide_pio_datablock()") missed tx4939ide driver.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

applied, thanks
