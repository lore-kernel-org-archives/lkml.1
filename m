Return-Path: <linux-kernel-owner+w=401wt.eu-S1161068AbXAaWNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161068AbXAaWNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 17:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161070AbXAaWNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 17:13:13 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:22793 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161068AbXAaWNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 17:13:12 -0500
Date: Wed, 31 Jan 2007 14:08:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Jones <davej@redhat.com>
Cc: Greg KH <greg@kroah.com>, Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-Id: <20070131140812.07ea6610.randy.dunlap@oracle.com>
In-Reply-To: <20070131220607.GB20157@redhat.com>
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org>
	<20070131201258.GB15128@kroah.com>
	<20070131220607.GB20157@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 17:06:07 -0500 Dave Jones wrote:

> On Wed, Jan 31, 2007 at 12:12:58PM -0800, Greg Kroah-Hartman wrote:
> 
>  > > There are many out-of-tree drivers (ivtv, lirc, various webcam drivers,
>  > > enhanced USB keyboard handlers...) with merging not planified or taking
>  > > ages.
>  > 
>  > See my above comment about lirc.  As for the others, everyone knows
>  > where we are at, and what the critera is for getting their code into the
>  > tree, so it's not like we are hiding anywhere :)
> 
> The webcam situation has bugged me a few times.  I regularly get reports
> from our users that they buy some new ov5xx based camera, and the in-tree
> driver doesn't work.  The out of tree one is a huge delta, and even
> begat a separate driver for the later chips iirc.
> 
> I contacted the upstream author a number of times to find out why he
> stopped sending updates. No replies.   Just taking his driver and
> sending updates myself seemed kinda rude, but at the same time,
> users are losing out.

Yes, I've contacted him (or one of him :) several times also
since I own one of those not-in-tree webcams...  Always some holdup.

---
~Randy
