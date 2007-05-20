Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbXETRTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbXETRTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 13:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbXETRTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 13:19:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:62880 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbXETRTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 13:19:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CSAmWhaP0VdwW3+7xoch/BXCfNaay7XI5AU/TEJOv0BRp3rAojGn+VosGR2B3Ia+aG5px2GoPkSltKbni9paSwtc1x1qBIl+Dmf/vsi5yzQKwt1fL5XaP5TkGqo5BH0TsJZ4gHVueAlS15t61qKON99fDZKR+eg77fR8LFhqcac=
Message-ID: <2c0942db0705201019g2808c62lec2fef8377559d9@mail.gmail.com>
Date: Sun, 20 May 2007 10:19:33 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Miguel Figueiredo" <elmig@debianpt.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Cc: "Bill Davidsen" <davidsen@tmr.com>,
       "Linux Kernel M/L" <linux-kernel@vger.kernel.org>
In-Reply-To: <46507E1D.6030002@debianpt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F57DD.2000309@tmr.com> <4650774F.9040208@debianpt.org>
	 <2c0942db0705200944r19a37bd8pd7c220903084e4d3@mail.gmail.com>
	 <46507E1D.6030002@debianpt.org>
X-Google-Sender-Auth: 4e30b9fd3194845f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Miguel Figueiredo <elmig@debianpt.org> wrote:
> > It doesn't look like you were running his glitch1 script which starts
> > several in glxgears parallel. Were you, or were you just running one?
>
> No i'm not, i'm running only one instance of glxgears inside the GNOME's
> environment.

Then not only were you on different hardware, but you weren't even
running the same test he was! He wasn't reporting raw numbers for one
glxgears, he was running several in parallel.

Whether your test is valid is a different question. Regardless, it's
not the same test he was doing, and so your results have no bearing on
his. You may wish to reread his message from the start of the thread,
and find the glitch1 script he was using to perform the test. He's
sent it to the list before as an attachment.
