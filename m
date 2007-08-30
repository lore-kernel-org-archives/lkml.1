Return-Path: <linux-kernel-owner+w=401wt.eu-S932992AbXH3TRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992AbXH3TRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 15:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759790AbXH3TRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 15:17:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:5724 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbXH3TRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 15:17:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P4xSLgmq2squSbAYKgWaFoFyV3L9oRy0jy/B9DjPsdMVR0Kd+65eL31plrjfcGpdbEXBvb/4olrZvaLY3yXV/LMZXAVVVRNflIzsZDa93GlQTpTNo3JnQ2wCpsofYyBHYmFwe6QfRTo7PVxBa8Dpgad5g+7Ku/a2NBBJ4/M8CZ8=
Message-ID: <68676e00708301217k7e0cf0edl4526bd79536ac065@mail.gmail.com>
Date: Thu, 30 Aug 2007 21:17:03 +0200
From: Luca <kronos.it@gmail.com>
To: "Alexey Starikovskiy" <astarikovskiy@suse.de>
Subject: Re: Linux 2.6.23-rc4: BAD regression
Cc: "Daniel Ritz" <daniel.ritz-ml@swissonline.ch>,
       linux-kernel@vger.kernel.org, "Len Brown" <len.brown@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708301020410.25853@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708290129.57243.daniel.ritz-ml@swissonline.ch>
	 <20070829232150.GA17467@dreamland.darkstar.lan>
	 <200708301907.56561.daniel.ritz-ml@swissonline.ch>
	 <alpine.LFD.0.999.0708301020410.25853@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/30/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 30 Aug 2007, Daniel Ritz wrote:
> >
> > i've just tested the minimal fix here:
> >       http://bugzilla.kernel.org/show_bug.cgi?id=8958#c7
> > works good so far. fan starts and system is responsive.
>
> Alexey, Len, can we get this fix integrated asap?

Tested here, works fine.

Luca
