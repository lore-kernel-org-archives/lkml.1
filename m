Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbXIST5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbXIST5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbXIST5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:57:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:25655 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbXIST5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:57:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JNAhBW1ggS7eIuWVFkLo6ZsK++phZ5jW0BMyAXlK6iLPrnuIXCcmruiUqhTbGHtFflFZyNrJvuTD3J/6jZ/p0WZ77DGIkjQnjVzFXWtAjuu+FcA4+2R+jeET26BNuo3HDV0IhEk3FiCQ7kJnPuKXFvub6Mmb+yRqGHyJ7I8vBs8=
Message-ID: <46F17F27.5080000@gmail.com>
Date: Wed, 19 Sep 2007 21:57:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <46F17CA1.5080205@gmail.com> <20070919195425.GF18707@one.firstfloor.org>
In-Reply-To: <20070919195425.GF18707@one.firstfloor.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2007 09:54 PM, Andi Kleen wrote:
>> Yeah. (But X doesn't run -- this is maybe the known issue in this release).
> 
> What do you mean with not run? 

(II) intel(0): Initializing HW Cursor
(II) intel(0): xf86BindGARTMemory: bind key 0 at 0x005ff000 (pgoffset 1535)
(WW) intel(0): xf86BindGARTMemory: binding of gart memory with key 0
        at offset 0x5ff000 failed (Invalid argument)

Fatal server error:
Couldn't bind memory for front buffer

I thought I'd seen a thread about this issue, but I can't find it now. Is it
known or am I seeing ghosts yet, Andrew?

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
