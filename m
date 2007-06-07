Return-Path: <linux-kernel-owner+w=401wt.eu-S936174AbXFGEl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936174AbXFGEl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 00:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbXFGElu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 00:41:50 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:20798 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbXFGElt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 00:41:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qrj7XimRS0bz9vaJJyTgUM0Gs6hRkOnJvLW28pvwbMiYHppuy+G4ZbHfZyeJ4RKo/Ud9VGvTxurZlddV00DQTKlljagBX4WHYTNnxqBJHzQuUGM+n91Gb77/m9yvlUglu112oaJXfTBi6IyX0xOytpUsS/IkoP2b+L2S8X+3IOk=
Message-ID: <4cefeab80706062141u5fea846ane51c90dc89732db5@mail.gmail.com>
Date: Thu, 7 Jun 2007 10:11:49 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Richard Purdie" <rpurdie@openedhand.com>
Subject: Re: [PATCH -mm] Add LZO1X compression support to the kernel
Cc: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1181150792.5686.51.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181150792.5686.51.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07, Richard Purdie <rpurdie@openedhand.com> wrote:
<snip>
>
> Nitin: Have you any objections to this version? If not, I'll finish
> analysing the PTR_ code changes and then hopefully we can get something
> into -mm...
>

Your code now looks nice and clean. But I don't know what you want. I
already spent lot of time on version 7 I posted and contains all those
corrections which were suggested for my earlier version. I cannot ask
you to look into possible problems (if any) in my code now since  you
are not interested in that anyway. So, please continue this
duplication.

Thanks,
Nitin
