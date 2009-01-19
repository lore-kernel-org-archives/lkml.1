Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbZASUDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbZASUDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZASUDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:03:41 -0500
Received: from kuber.nabble.com ([216.139.236.158]:41159 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZASUDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:03:40 -0500
Message-ID: <21550460.post@talk.nabble.com>
Date: Mon, 19 Jan 2009 12:03:39 -0800 (PST)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel vs user memory
In-Reply-To: <49718851.9010901@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
References: <21512362.post@talk.nabble.com> <49717A28.2060106@zytor.com> <21513615.post@talk.nabble.com> <49717D03.2030205@zytor.com> <21513643.post@talk.nabble.com> <49718851.9010901@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the help, makes things a lot clearer


H. Peter Anvin wrote:
> 
> sidc7 wrote:
>> One last question, which one of the two lowmem or highmem kernel is most
>> commonly used on contemporary linux boxes. I am guessing highmem kernel ?
>> 
>> Thanks for the quick replies, helped a lot
> 
> For PCs, 32 bit is generally highmem, and 64 bits is lowmem.  Most
> embedded systems are lowmem.
> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
View this message in context: http://www.nabble.com/Kernel-vs-user-memory-tp21512362p21550460.html
Sent from the linux-kernel mailing list archive at Nabble.com.

