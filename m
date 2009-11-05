Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbZKEUdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbZKEUdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbZKEUdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:33:13 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:48137 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758508AbZKEUdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:33:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OnTYJl+dNbDTcHuvo0bwBgBgUhhsDdHGe8M+w8dmcKHnPJkuQZmXfftuBZZ4pjSbce
         i5uLlhp0ZHsyayk4OteJLFaY3XQFKivhJpSZhAw67jm/8H/Rhg3tjzHseP0xYGjB7Ma8
         4tyYhTqJ9+aYbf4gCXeTWXw45Ot+TXff8M7OY=
Message-ID: <4AF3367D.4050303@gmail.com>
Date: Thu, 05 Nov 2009 21:33:01 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090926 Lightning/1.0pre Shredder/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 31/41] rt2800usb: add RXINFO_DESC_SIZE definition
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173547.28463.36376.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173547.28463.36376.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/09 18:35, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: add RXINFO_DESC_SIZE definition
> 
> Add RXINFO_DESC_SIZE definition and use it instead of abusing
> RXD_DESC_SIZE one (TXD_DESC_SIZE and RXD_DESC_SIZE are specific
> to PCI version of the chipset).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
