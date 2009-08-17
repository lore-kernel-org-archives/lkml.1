Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbZHQUXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbZHQUXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZHQUXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:23:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:36671 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbZHQUXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Oc4++gaoJKYkezfMOjiSX0CxDWYrRkRvupiZJVag4v5VN47jVznK+tp1kTHFiKj4yK
         jFCNBiKqbh5TzM3+epIxBVv8Z8ESoQV5ZQLJxIo1snJXzkYYQeu3rrEJQ0SIE+yfK/sZ
         51+Fe3EUEOBdAhN15BZYXTF2W7iHi4JV1/axo=
Message-ID: <4A89BC79.4070200@gmail.com>
Date: Mon, 17 Aug 2009 13:24:25 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ohci1396_dma=early nogo on an imac?
References: <4A88F6BF.7090104@gmail.com> <4A89722A.1070407@s5r6.in-berlin.de> <dd18b0c30908171104o7ed67aa3x7cab741263de09c3@mail.gmail.com> <4A899D41.7000405@s5r6.in-berlin.de> <4A89A7C0.1090909@gmail.com> <4A89BA75.6040900@s5r6.in-berlin.de>
In-Reply-To: <4A89BA75.6040900@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Justin P. Mattock wrote:
>> The problem im seeing is if I use ohci1394_dma=early on the bad kernel
>> instantly Ill get a message on the screen saying:
>>
>> PANIC: early exception 08 rip 246:10 error ffffffff8145ff15 cr2 0
>
> Hmm, as I am not familiar with anything related to early 
> initialization, I have no idea what it means let alone what causes it.
neither do I, at the moment I'll load
2.6.31-rc5 to see if I hit this, then
ill go through all of the commits up to rc6
if not ill have to start back with 2.6.30.4
and work my way up.

Justin P. Mattock
