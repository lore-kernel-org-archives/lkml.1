Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYGEToo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYGEToo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 15:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYGETog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 15:44:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:40216 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbYGETof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 15:44:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Wquiuzka5UHDNHyJfQ58Frs3GukDn+FJvPrW3sJPto4/vwjYbQWQghyovu2Ro/o6JC
         8gzhLM0jaY8TbdgHzxRIhlRT4FFPuIMHKtN6WafhbGlo1JPiL9vY0YOAvS4HQonw4I3T
         UZvfGVtStoYype6HeGtbJDq4TEHpuufAedO5o=
Message-ID: <31e679430807051244k55efa331rdb57673db5ac37cf@mail.gmail.com>
Date: Sat, 5 Jul 2008 22:44:35 +0300
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: Battery life difference
Cc: "Kernel development list" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20080705123438.15c8de40@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <31e679430807050617u3fc706fasee9bb43a151c501f@mail.gmail.com>
	 <20080705082352.4b6be669@infradead.org>
	 <31e679430807050844r30ff74fby7e15641573b42d82@mail.gmail.com>
	 <20080705085432.2f9b2964@infradead.org>
	 <31e679430807051041w6dd9b917xc51f31f66fbd65d3@mail.gmail.com>
	 <20080705123438.15c8de40@infradead.org>
X-Google-Sender-Auth: fe89bdbcf65df00d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 5, 2008 at 10:34 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> actually.. it needs to/is moving into the driver. This sort of decision
> needs to just happen locally in the driver; the idea that you can make
> power decisions (rather than policy decisions) on a global level is
> just no longer true (if it ever was).

Got your point. Just like in omap, we're putting everything in the driver
itself.

> Actually I thought this was already in the 2.6.26-rc kernel series
> driver...

At least powertop still complains about it. Maybe it's queued for
2.6.27 ?

btw, do you know if any company is selling x-series power adapters
to be attached to controlled power supplies or would I have to cut one of
my power supply cords (not willing to do that :-p)?

-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
