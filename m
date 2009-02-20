Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZBTEux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZBTEux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 23:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZBTEup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 23:50:45 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:16526 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbZBTEuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 23:50:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Td+z/KO9XTweKB1QAArFYyaI7xCM0/mQAaLnpCWnMiD6bCLv0ge6oEWulNzVMpTyID
         wJcoOZ/5mUY9dJu0/757ZYjDVL2nv62iHLXeXw6gHlF9R/kF+YC/PMIaIVbyy9z68AEi
         KUE9xdqnP/rpSSBQ/dolqcLs2jXRDM7Bi14Kc=
MIME-Version: 1.0
In-Reply-To: <20090219144713.192894dd.akpm@linux-foundation.org>
References: <4d34a0a70902181905v20b0971ep80af49686b8b27dd@mail.gmail.com>
	 <4d34a0a70902181923h75a34efx5ff9dc67d83830b7@mail.gmail.com>
	 <20090219144713.192894dd.akpm@linux-foundation.org>
Date: Fri, 20 Feb 2009 13:50:43 +0900
Message-ID: <4d34a0a70902192050r461f7475k385d0b293386aa8@mail.gmail.com>
Subject: Re: [PATCH] leds: Add BD2802GU LED driver
From: Kim Kyuwon <chammoru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>
> Your email client has wordwrapped the patch and has replaced all tabs
> with eight spaces.  Please fix that up when resending.
> Documentation/email-clients.txt has some gmail tips.
>
> I had a go at cleaning it up, and found lots of code whcih was indented
> with seven-spaces.  Perhaps this file was origininaly edited with
> space-space-space-space indenting.  If so, please don't do that - use
> hard tab characters.
>
> Anyway, I ended up with soemthing reasonable-looking which actually
> compiles.  Please check the result.
>

To make sure that this patch is well-formated, I sent this patch to myself
first, and then forwarded it to the LKML. I think this 'forwarding' makes the
problem worse. Sorry for the problem :)

And thank you for reviewing this driver and giving me valuable comments.

I will resend the patch as following Gmail tips in 'email-clients.txt'
and yours.

Regards,

-- 
Kim Kyuwon
