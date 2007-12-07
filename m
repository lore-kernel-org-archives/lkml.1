Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbXLGL55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbXLGL55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 06:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbXLGL5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 06:57:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:43552 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbXLGL5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 06:57:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xk2EECn7mXBRr/9RTF5MAaTocHSAwpE27sGkDy1san2FruAmcVGJ+Y+MpVS1Xp1jvkrQtNpT4smLJO4nrnjjAIIzKS4d0qJXDU2+Jt4GnvjWiM+iwD20aLqTyK/VAFQ1GtX2QufY6CW7dTkV5sorevV46aKeIt95IbhQSJYrkt0=
Message-ID: <3d8471ca0712070357q54a91cf9g63e0afba02902d3e@mail.gmail.com>
Date: Fri, 7 Dec 2007 12:57:46 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Cc: "Ingo Molnar" <mingo@elte.hu>, "Stefano Brivio" <stefano.brivio@polimi.it>,
       "Robert Love" <rml@tech9.net>, linux-kernel@vger.kernel.org,
       "Dave Jones" <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Michael Buesch" <mb@bu3sch.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <lenb@kernel.org>
In-Reply-To: <3d8471ca0712070318x73ad05e4v4b6393d9aeeb3dfe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071207021952.6f0ac922@morte> <20071207084559.GA11162@elte.hu>
	 <200712072213.06530.nickpiggin@yahoo.com.au>
	 <3d8471ca0712070318x73ad05e4v4b6393d9aeeb3dfe@mail.gmail.com>
X-Google-Sender-Auth: 52b1fe06608f0e37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007 12:18 PM, Guillaume Chazarain <guichaz@yahoo.fr> wrote:
> Any pointer to it?

Nevermind, I found it ... in this same thread :-(

-- 
Guillaume
