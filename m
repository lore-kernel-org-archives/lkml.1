Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbXKODKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbXKODKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 22:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbXKODJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 22:09:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:1712 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbXKODJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 22:09:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HpMPQYhX0z1NdfaKx0cWUesxAXXyw2iffGrD3iUMUK3IXZG4GxE8Bf1sKFjVky9GwBErhJl6szLcamXnPVPcy/f7eAJNDdQyuMWvW6H8ZO9WEZd1NGtC0yL6IpSoTRH+Pg0wWhIUKe8TqOZ/bEu6QQSZpXw5W+LYbfBGiG/5xxk=
Message-ID: <473BB7CF.7020801@gmail.com>
Date: Thu, 15 Nov 2007 12:06:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] pata_sis.c: Add Packard Bell EasyNote K5305 to laptops
References: <473A0B57.4030703@googlemail.com>
In-Reply-To: <473A0B57.4030703@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Hi,
> 
> With newer kernels HDD in my old laptop is limited to UDMA 33.
> With this patch I get UDMA 100 again.
> 
> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

applied to #tj-upstream-fixes with Hi, edited out.  :-)

-- 
tejun

