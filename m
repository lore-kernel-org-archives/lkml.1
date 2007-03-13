Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbXCMB5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbXCMB5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 21:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXCMB5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 21:57:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:35452 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbXCMB5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 21:57:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VjnLjNYY9Qdtl1huyYTw17HAgBnSFI9i6kBFfM9WLp5JQKZv4x8iCYUDK1zpBzPw6bSQjHV/wxU8p5Gvv3Cshgbv/th4PmCeLNlDqtatlvXM/JWW0eKtdfpNfCQQ/LXEeiiWN8b1VEA18YxT3RsMwi9s1ZgKA3LTQnOEsNyoM+I=
Message-ID: <661de9470703121857pc695e3cp2c3c853be3622689@mail.gmail.com>
Date: Tue, 13 Mar 2007 07:27:06 +0530
From: "Balbir Singh" <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
To: "Balbir Singh" <balbir@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Emelianov" <xemul@sw.ru>, Kirill@osdl.org, Linux@osdl.org,
       containers@lists.osdl.org, "Paul Menage" <menage@google.com>,
       List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/7] RSS controller core
In-Reply-To: <20070312234335.GA11578@MAIL.13thfloor.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	 <20070306140036.4e85bd2f.akpm@linux-foundation.org>
	 <20070309164855.GB3647@MAIL.13thfloor.at>
	 <661de9470703120255k4c4c1d0fy97a2b7a033c7b5b1@mail.gmail.com>
	 <20070312234335.GA11578@MAIL.13thfloor.at>
X-Google-Sender-Auth: d807cff608c28dbf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> hmm, it is very unlikely that this would happen,
> for several reasons ... and indeed, checking the
> thread in my mailbox shows that akpm dropped you ...
>

But, I got Andrew's email.

> --------------------------------------------------------------------
> Subject: [RFC][PATCH 2/7] RSS controller core
> From: Pavel Emelianov <xemul@sw.ru>
> To: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
>         Srivatsa Vaddagiri <vatsa@in.ibm.com>,
>         Balbir Singh <balbir@in.ibm.com>
> Cc: containers@lists.osdl.org,
>         Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Date: Tue, 06 Mar 2007 17:55:29 +0300
> --------------------------------------------------------------------
> Subject: Re: [RFC][PATCH 2/7] RSS controller core
> From: Andrew Morton <akpm@linux-foundation.org>
> To: Pavel Emelianov <xemul@sw.ru>
> Cc: Kirill@smtp.osdl.org, Linux@smtp.osdl.org, containers@lists.osdl.org,
>         Paul Menage <menage@google.com>,
>         List <linux-kernel@vger.kernel.org>
> Date: Tue, 6 Mar 2007 14:00:36 -0800
> --------------------------------------------------------------------
> that's the one I 'group' replied to ...
>
> > Could you please not modify the "cc" list.
>
> I never modify the cc unless explicitely asked
> to do so. I wish others would have it that way
> too :)
>

Thats good to know, but my mailer shows


Andrew Morton <akpm@linux-foundation.org>
	to		Pavel Emelianov <xemul@sw.ru>	
	cc	
	Paul Menage <menage@google.com>,
Srivatsa Vaddagiri <vatsa@in.ibm.com>,
Balbir Singh <balbir@in.ibm.com> (see I am <<HERE>>),
devel@openvz.org,
Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
containers@lists.osdl.org,
Kirill Korotaev <dev@sw.ru>	
	date		Mar 7, 2007 3:30 AM	
	subject		Re: [RFC][PATCH 2/7] RSS controller core	
	mailed-by		vger.kernel.org	
On Tue, 06 Mar 2007 17:55:29 +0300

and your reply as

Andrew Morton <akpm@linux-foundation.org>,
Pavel Emelianov <xemul@sw.ru>,
Kirill@smtp.osdl.org,
Linux@smtp.osdl.org,
containers@lists.osdl.org,
Paul Menage <menage@google.com>,
List <linux-kernel@vger.kernel.org>	
	to		Andrew Morton <akpm@linux-foundation.org>	
	cc	
	Pavel Emelianov <xemul@sw.ru>,
Kirill@smtp.osdl.org,
Linux@smtp.osdl.org,
containers@lists.osdl.org,
Paul Menage <menage@google.com>,
List <linux-kernel@vger.kernel.org>	
	date		Mar 9, 2007 10:18 PM	
	subject		Re: [RFC][PATCH 2/7] RSS controller core	
	mailed-by		vger.kernel.org

I am not sure what went wrong. Could you please check your mail
client, cause it seemed to even change email address to smtp.osdl.org
which bounced back when I wrote to you earlier.

> best,
> Herbert
>

Cheers,
Balbir
