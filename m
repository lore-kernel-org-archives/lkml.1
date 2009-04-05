Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbZDEGfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbZDEGfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 02:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbZDEGfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 02:35:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbZDEGfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 02:35:01 -0400
Message-ID: <49D8510A.3010606@zytor.com>
Date: Sat, 04 Apr 2009 23:34:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Bryan Henderson <hbryan@us.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Replacing VFAT as filesystem on removeable media
References: <OFF614A035.0DA52102-ON8825758C.00613C94-8825758C.006215D5@us.ibm.com> (sfid-20090403_102506_091012_8ECF2D52) <200904031029.03581.Martin@lichtvoll.de>
In-Reply-To: <200904031029.03581.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
>>
>> How do you mean "replace"?
>>
>> VFAT's standardness today comes from the fact that virtually every
>> personal computer in the world today and for the foreseeable future is
>> able to read and write VFAT.  Do you envision some other filesystem
>> format achieving that status?
> 
> That was my (possibly crazy) idea yes. ;)
> 

Ironically enough, one of the better filesystems for being supported by
many OSes is probably ext2.  However, that doesn't mean it is even in
the same rough ballpark as (V)FAT.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

