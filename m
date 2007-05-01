Return-Path: <linux-kernel-owner+w=401wt.eu-S1031681AbXEAMEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031681AbXEAMEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 08:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031684AbXEAMEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 08:04:24 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:51092 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031681AbXEAMEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 08:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=XifOBLVeKuWQTiE0e+b7soYUESkIbNhrhR4SK4woj1O1kOxk1wnS4tVtdJXBkJ4QyJoh4BXzouDBBdw/ED3z3opibMbRhmdyZvXh0e6oS8rhW8TKbEW5pyV0fiLWcXMO0q/Y+IZK8X7JH+ajOqJlYRfC8B+dBI4gt5oF1yPHuAc=
Date: Tue, 1 May 2007 15:04:18 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <1173924397.20070501150418@gmail.com>
To: Jamey Hicks <jamey@handhelds.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       <kernel-discuss@handhelds.org>
Subject: Re: [RFC, PATCH 2/4] SoC base drivers: ASIC3 SoC hardware definitions
In-Reply-To: <20070501112751.6b1d9452@the-village.bc.nu>
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org> <20070501112751.6b1d9452@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan,

Tuesday, May 1, 2007, 1:27:51 PM, you wrote:

>> > + * Copyright 2001 Compaq Computer Corporation.
>> > + *
>> > + * Use consistent with the GNU GPL is permitted,
>> > + * provided that this copyright notice is
>> > + * preserved in its entirety in all copies and derived works.
>> > + *
>> > + * COMPAQ COMPUTER CORPORATION MAKES NO WARRANTIES, EXPRESSED OR IMPLIED,
>> > + * AS TO THE USEFULNESS OR CORRECTNESS OF THIS CODE OR ITS
>> > + * FITNESS FOR ANY PARTICULAR PURPOSE.

> This doesn't appear to be self consistent or GPL compatible. Any binary
> will be a derivative work and will not contain the copyright notice.

        Well, this is one of those hard questions... Fortunately,
people who worked on this and were Compaq employees are reachable, so
I contacted Jamie Hicks, who is one of the authors of iPaq ports,
regarding solution for this. Jamie, would it be possible to leave
Compaq and other copyright notices, and Compaq disclaimer intact,
but replace following paragraph:

> + * Use consistent with the GNU GPL is permitted,
> + * provided that this copyright notice is
> + * preserved in its entirety in all copies and derived works.

        With more common wording as appears in kernel sources:

>   This program is free software; you can redistribute it and/or modify
>   it under the terms of the GNU General Public License as published by
>   the Free Software Foundation; either version 2 of the License, or
>   (at your option) any later version.

(or GPL2 wording, or verbose wording, whatever you see fit)

Thanks!

> Alan


-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

