Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbXHAFpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbXHAFpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 01:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbXHAFpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 01:45:32 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:57706 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbXHAFpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 01:45:32 -0400
Date: Wed, 01 Aug 2007 01:45:29 -0400
To: <akpm@linux-foundation.org>
Cc: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-sound@vger.kernel.org>
Subject: Re: [PATCH]:  sound: ioremap/iounmap function balancing audit
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070801054530.B6459DA820@mailserver8.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007 00:52:26 -0400 Andrew Morton <akpm@linux-
foundation.org> wrote:
>The patch is terribly wordwrapped.
>
>I suspect a lot of the code which you're fixing is about to be 
>removed. 
>But I suppose we should fix it before removing it anwyay.  Still, 
>please
>split this patch into at least one for sound/oss and one for 
>sound/soc and
>sound/pci, thanks.

Will do, though wordwrapping issues will still be there.  The part 
of the function I was patching in i810_probe is nested so deep 
birds have taken up residence.

---------------------------------------
Scott Thompson / postfail@hushmail.com
---------------------------------------

--
Rock bottom prices! Click to save on brand name copiers today
http://tagline.hushmail.com/fc/Ioyw6h4efL27NZWTgRQ5KLEGpGlRXMwVmKYR73wM4wS274Lb73uEK4/

