Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbXEBKh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbXEBKh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993026AbXEBKh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:37:57 -0400
Received: from rex.snapgear.com ([203.143.235.140]:42540 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754311AbXEBKh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:37:56 -0400
Message-ID: <463869FB.7000209@snapgear.com>
Date: Wed, 02 May 2007 20:37:47 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: linux-2.6.21-uc0 (MMU-less updates)
References: <46382055.8030203@snapgear.com> <20070502090620.GB28174@infradead.org>
In-Reply-To: <20070502090620.GB28174@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Christoph,

Christoph Hellwig wrote:
> On Wed, May 02, 2007 at 03:23:33PM +1000, Greg Ungerer wrote:
>> Hi All,
>>
>> An update of the uClinux (MMU-less) code against 2.6.21.
>> A lot of cleanups, and a few bug fixes.
> 
> Any chance you could split this into a few patches and send
> upstream? m68knommu has gone quite badly out of sync once again.

Yes, I have already started the process. I have sent quite
a few of these to Linus in the last few hours.

Regards
Greg


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
