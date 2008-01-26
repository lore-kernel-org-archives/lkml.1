Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbYAZHXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbYAZHXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 02:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYAZHXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 02:23:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:14808 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYAZHXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 02:23:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Uvo82tz0WTYzOusAFLU2ZFx/3+9iwea7izisegOs6SsvEBAIRjPgDzR5v5Ub90gx9fv67MQM9VAGScwJ9myU7kTptQHXJ8LTP4JnRDXYULzJKQrI7sk9NczPzTs6x9GkbBN6pTNVLbm9aX4iZHmSH5ZFu0lNPVVjarcJiS6SAFo=
Message-ID: <517f3f820801252323q38e972f8v5e13d5bd8c7188a1@mail.gmail.com>
Date: Sat, 26 Jan 2008 08:23:01 +0100
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [PATCH] RUSAGE_THREAD
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Vinay Sridhar" <vinay@linux.vnet.ibm.com>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080119011418.850DD26F9FD@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200558425.5992.17.camel@srivinay.in.ibm.com>
	 <20080119011418.850DD26F9FD@magilla.localdomain>
X-Google-Sender-Auth: 671c28241eb91055
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 19, 2008 2:14 AM, Roland McGrath <roland@redhat.com> wrote:
>
> This adds the RUSAGE_THREAD option for the getrusage system call.
> Solaris calls this RUSAGE_LWP and uses the same value (1).
> That name is not a natural one for Linux, but we keep it as an alias.

Hey Roland,

Would you please CC at this address me on patches that change the
kernel-userland API.

Cheers,

Michael
