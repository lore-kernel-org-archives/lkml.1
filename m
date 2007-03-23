Return-Path: <linux-kernel-owner+w=401wt.eu-S1422801AbXCWLUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422801AbXCWLUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 07:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422791AbXCWLUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 07:20:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:49086 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422801AbXCWLUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 07:20:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RQDWrtE9WbKJK2W5Qt8FWxwHn84SDSCWbu5ILy7qXO5c/0VojTlsCmfprn8fEdzihF4aoenKU6XRM1amTJcjgvv7Fh357FHeZaXxUae/TzLJkMd7M8nVng0JSyGUvb+TNakW2IFJZz5VgEYvPwcSzzxAj/LRM/9PuHAyODTxLgc=
Message-ID: <3aa654a40703230420o28c85bd4m3823d40a64da8617@mail.gmail.com>
Date: Fri, 23 Mar 2007 04:20:47 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Jack Malmostoso" <malmostoso@email.it>
Subject: Re: MCE on an NForce4 board (again)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87bed1533206ce7ce9bf4753d2a042f5@129.129.233.87>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87bed1533206ce7ce9bf4753d2a042f5@129.129.233.87>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/07, Jack Malmostoso <malmostoso@email.it> wrote:
> Hi there list,
>
> this is a repost from the x86-64.org discuss list. I think it could be
> relevant here too, if not please excuse me and forget this message. I am not
> subscribed to the LKML, but I can follow the thread on usenet, so no need to
> CC. Feel free to do it if you think it's relevant!

I had this problem before. After much debugging and hair pulling I
contacted the manufacturer who said they wern't going to try to figure
out my issue due to my unwillingness to run Win. Went to the store to
replace the motherboard with the same model, the problem persisted.
Replaced the motherboard with a different model the problem completely
went away.

http://marc.info/?l=linux-kernel&m=113239372109342&w=2
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
