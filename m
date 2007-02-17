Return-Path: <linux-kernel-owner+w=401wt.eu-S2992992AbXBQSpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992992AbXBQSpI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993059AbXBQSpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:45:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992992AbXBQSpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:45:06 -0500
Message-ID: <45D74D34.5020201@redhat.com>
Date: Sat, 17 Feb 2007 13:45:08 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: michael chang <thenewme91@gmail.com>, ck mailing list <ck@vds.kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: 2.6.20-ck1
References: <200702162110.03355.kernel@kolivas.org> <200702171213.40718.kernel@kolivas.org> <b14e81f00702161815x13c25936r49f540beeda3e334@mail.gmail.com> <200702171417.28376.kernel@kolivas.org>
In-Reply-To: <200702171417.28376.kernel@kolivas.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> Maintainers are far too busy off testing code for 
> 16+ cpus, petabytes of disk storage and so on to try it for themselves.  Plus 
> they worry incessantly that my patches may harm those precious machines' 
> performance... 
> 

But the one I like, mm-filesize_dependant_lru_cache_add.patch,
has an on-off switch.

In other words it adds an option to do things differently.
How could that possibly affect any workload if that option
isn't enabled?

