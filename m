Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbXLNSrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbXLNSrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbXLNSrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:47:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:4555 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbXLNSro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:47:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=J3TD2dT7tuMQewoiH8wFL9aAFia085o8Moz0Kha4ZsXBEvvYwpixL1QU3o4MwWpBS88FFhyBTAEe9fpSvbeZ5Te9X2K3HTLe/jlcwULxLMXuOdQsfSgWjN2QquQ8eCpPPg+eo4I1DubzOOxQIJUU/W+h0Zl93BaM8h/qWScw+1k=
Message-ID: <2c0942db0712141047x7da48cb9i49e306c3ce0c39eb@mail.gmail.com>
Date: Fri, 14 Dec 2007 10:47:43 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Michael Buesch" <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
       "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       "John Linville" <linville@tuxdriver.com>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <20071214181109.GA32350@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <200712141409.00311.mb@bu3sch.de>
	 <2c0942db0712140806p61ec06d5nf3289dab938fd93a@mail.gmail.com>
	 <200712141749.33708.mb@bu3sch.de>
	 <2c0942db0712141001l6ad77657q1dceee5cb872a979@mail.gmail.com>
	 <20071214181109.GA32350@elte.hu>
X-Google-Sender-Auth: 550babb7a48a616f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 10:11 AM, Ingo Molnar <mingo@elte.hu> wrote:
> * Ray Lee <ray-lk@madrabbit.org> wrote:
>
> > Now I'm going to go off, sit in the sun, sip some coffee, and think
> > happy thoughts of kittens playing with yarn for a while.
>
> ok, and given the time-shift and apparent season-shift i'll sit in the
> evening, watch the snowfall and think happy thoughts of kittens

Heh :-). Sometimes I feel guilty living in coastal California. But our
seasons are more along the lines of fire, flood, earthquake, and riot
:-).

Ray
