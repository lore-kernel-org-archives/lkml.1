Return-Path: <linux-kernel-owner+w=401wt.eu-S2993088AbXDYUZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993088AbXDYUZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993089AbXDYUZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:25:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:60580 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993088AbXDYUZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FyGZVLmzeAVyg5NcXVvazPCn+uwePt89Dpc/5tNzrOuzHoxL6Wra+h8sfmM4S1dsj32Sb8+ZUsKJOHzvfjq94Lfd0v0f+kwI1BqFA4aG32qPt8oIz+CJmMq4A0GYnH67QsHv873bK270TW8lXKPdF7Q57QWYdHkl8gLhbvfTk18=
Message-ID: <75b66ecd0704251325y3a58675ev65614d7b304c2e2a@mail.gmail.com>
Date: Wed, 25 Apr 2007 16:25:29 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "William Heimbigner" <icxcnika@mar.tar.cc>
Subject: Re: cpufreq default governor
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704241252410.25153@server.thyself>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704240755230.25153@server.thyself>
	 <6bffcb0e0704240134w45007473p5694718a0aae08fc@mail.gmail.com>
	 <Pine.LNX.4.64.0704241235560.25153@server.thyself>
	 <6bffcb0e0704240550x2c47cd1ap8101a9b0db5c6c7d@mail.gmail.com>
	 <Pine.LNX.4.64.0704241252410.25153@server.thyself>
X-Google-Sender-Auth: c0efd5bc6641010d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/07, William Heimbigner <icxcnika@mar.tar.cc> wrote:
> Is it actually "not working" though, even at the hardware level? To my
> knowledge those noises are normal, and aren't even signs of a harware
> problem. I believe it is the natural result of changing frequencies at any
> time. If you change frequencies, especially in the low end of available
> frequencies, you should hear a very brief noise. A governor such as
> ondemand, which is rapidly switching the frequency from say, 333 MHz to
> 2.66 GHz, is likely to make this much more noticable.

It's only normal if your vendor used cheap noisy components.  This
would be a fatal flaw for a system that was intended for audio
production for example.

Lee
