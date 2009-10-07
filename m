Return-Path: <linux-kernel-owner+w=401wt.eu-S933996AbZJGI6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996AbZJGI6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932927AbZJGI6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:58:07 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:40928 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729AbZJGI6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DbvLPcknUXcHNY94Qj340ssyv+aZef1GRSN14SCyjQriM6XNwO9klkkCYRXxbl7J/j
         IhlmLcEoIF0DoQTVOfv+o4ttmra01XvTnZ1f4FhZw5t4LqQE4iLXnX5zCSl3Kv1qvCLD
         GKpWEdgA9CFGOsFNdsqhEb33hxIBBaH7HYWhk=
MIME-Version: 1.0
In-Reply-To: <1254302501.23991.90.camel@tubuntu>
References: <1253793384-31158-1-git-send-email-tomi.valkeinen@nokia.com>
	 <1254302501.23991.90.camel@tubuntu>
Date: Wed, 7 Oct 2009 11:57:27 +0300
Message-ID: <94a0d4530910070157v2dd8062aheffc6345daff9e78@mail.gmail.com>
Subject: Re: [PATCH 00/19] OMAP: DSS2: Intro
From: Felipe Contreras <felipe.contreras@gmail.com>
To: tomi.valkeinen@nokia.com
Cc: ext Andrew Morton <akpm@linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 12:21 PM, Tomi Valkeinen
<tomi.valkeinen@nokia.com> wrote:
> Hi,
>
> Andrew, do you have time to check out the DSS2 driver? Or suggestions
> how should I proceed.
>
> I rebased DSS2 on top of today's linux-tree, and there were no
> conflicts, so the posted patches should apply. But the rebased tree is
> also available in master branch at
> git://gitorious.org/linux-omap-dss2/linux.git

It's also worth noting that DSS2 is used basically on all linux-omap
trees already, I've seen it working at least on N900 and beagleboard
and it makes no sense to try to get some video output without it.

P.S. I had to patch the beagleboard support from Tomi's
'master-before-squash'... it would be nice to get it upstream already

-- 
Felipe Contreras
