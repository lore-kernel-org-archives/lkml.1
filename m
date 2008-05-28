Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYE1Vuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYE1Vuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755719AbYE1Vuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:50:40 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:39941 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbYE1Vuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:50:39 -0400
Date: Wed, 28 May 2008 17:50:37 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: floppy question of the hour
In-reply-to: <483DB49D.7040706@cfl.rr.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Message-id: <200805281750.37310.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200805232114.20937.gene.heskett@gmail.com>
 <20080528134257.GA16164@csclub.uwaterloo.ca> <483DB49D.7040706@cfl.rr.com>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2008, Phillip Susi wrote:
>Lennart Sorensen wrote:
>> Just do what the Amiga did:  Read the entire track into a buffer in
>> memory, then deal with the sectors, and write the entire track back. :)
>
>IIRC, there is no way to detect the interleave factor that the media has
>been formatted with, unless you maybe try several and see which one
>reads fastest.

ilv=3 reads the fastest by a wide margin on the target machine.

Thanks Guys.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
God made everything out of nothing, but the nothingness shows through.
		-- Paul Valery
