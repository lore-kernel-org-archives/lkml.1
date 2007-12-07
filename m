Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbXLGLTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbXLGLTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 06:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXLGLS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 06:18:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:46202 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbXLGLSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 06:18:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FSfR9wzzoJoMFYqP2G6/QRKrv9IRHTkw27tRuxhKIKvuHuOsKAaBlLdOz31Qe7hVj/KO9xV7upM6dn00C091GhI91H78aLgWUywe3LUGsAaa3zY8Sl7Cj95MyU8WN/Z0+zHDxzqeLJPyIOBDuRcjZCgBi4RG6vn+kxSCcdQ1Ba0=
Message-ID: <3d8471ca0712070318x73ad05e4v4b6393d9aeeb3dfe@mail.gmail.com>
Date: Fri, 7 Dec 2007 12:18:53 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Cc: "Ingo Molnar" <mingo@elte.hu>, "Stefano Brivio" <stefano.brivio@polimi.it>,
       "Robert Love" <rml@tech9.net>, linux-kernel@vger.kernel.org,
       "Dave Jones" <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Michael Buesch" <mb@bu3sch.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <lenb@kernel.org>
In-Reply-To: <200712072213.06530.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071207021952.6f0ac922@morte> <20071207084559.GA11162@elte.hu>
	 <200712072213.06530.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: 4ad3e0f643f8b193
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007 12:13 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> My patch should fix the worst cpufreq sched_clock jumping issue
> I think.

Any pointer to it?

Thanks.

-- 
Guillaume
