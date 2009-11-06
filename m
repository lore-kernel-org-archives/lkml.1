Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbZKFTx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbZKFTx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 14:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759717AbZKFTx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 14:53:57 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:33643 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759702AbZKFTx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 14:53:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nx54iTF4xRCynlRcG01dsevj+KYzK6tngILqbBu3vfLigX67y9Gs1EIWw35OumShlT
         MVuEMSrSKeOwN4doKvgFCubSfPNKU0pd18dNVo+UU4X9AH8izecpRCo5IJtOFvZZOH0p
         eiy+XbWoxcyf9vtk/BjTCoRS/xMK4iGzWUAwY=
Message-ID: <4AF47ED4.6090901@gmail.com>
Date: Fri, 06 Nov 2009 20:53:56 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090926 Lightning/1.0pre Shredder/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 02/41] rt2800pci: make Kconfig help entry more helpful
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173210.28463.95558.sendpatchset@localhost.localdomain> <14add3d10911041026r54a0abd1h953609dd7cb7224a@mail.gmail.com> <200911061713.09133.bzolnier@gmail.com>
In-Reply-To: <200911061713.09133.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/09 17:13, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 04 November 2009 19:26:16 Gertjan van Wingerde wrote:
>> On Wed, Nov 4, 2009 at 6:32 PM, Bartlomiej Zolnierkiewicz
>> <bzolnier@gmail.com> wrote:
>>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> Subject: [PATCH] rt2800pci: make Kconfig help entry more helpful
>>>
>>> Document known issues with the driver to aid distribution makers,
>>> users and developers in making informed decisions instead of wasting
>>> their time needlessly.
>>>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> ---
>>> This reflects the actual state of affairs for driver in net-next tree.
>>>
>>
>> Maybe we should consider making this one depend on BROKEN, for the
>> moment at least?
> 
> Sounds fine with me, would you be willing to take care of this?
> 

Sure. No problem. Will produce a patch once your series has been merged.

---
Gertjan.

