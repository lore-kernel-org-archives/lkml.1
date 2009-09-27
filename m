Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbZI0BgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbZI0BgJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 21:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZI0BgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 21:36:07 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:34030 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbZI0BgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 21:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QKi+cnefWWGVX616WVSDcVkzdObwuVeF3+sRvxWGE1pq9GvxnMZRIyrjKQkCdyhseG
         hh+XxTXnwvM6Cxagy+QhKZgC2l4XM3/tHBb1KDgI+9LJNXZroCnzqx1KZWQTN+SoPTlR
         BqQSenln/vMNswoZtuVwBw2ZVUZ9Ut+b6hFMI=
MIME-Version: 1.0
In-Reply-To: <1253974303.4568.13.camel@ht.satnam>
References: <1253974303.4568.13.camel@ht.satnam>
Date: Sun, 27 Sep 2009 02:36:09 +0100
Message-ID: <3d374d00909261836g38ceceb0p3fed39ac62103c33@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP: Remove unused CONFIG MACH_OMAP_HTCWIZARD
From: Alistair Buxton <a.j.buxton@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "Zebediah C. McClure" <zmc@lurian.net>, Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/26 Jaswinder Singh Rajput <jaswinder@kernel.org>:
>
> Remove unused CONFIG MACH_OMAP_HTCWIZARD from Kconfig

Don't do it please! We're working on it.... board file is coming very soon.

-- 
Alistair Buxton
a.j.buxton@gmail.com
