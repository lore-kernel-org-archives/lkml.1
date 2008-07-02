Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbYGBXZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbYGBXZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 19:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYGBXZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 19:25:48 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:65142 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbYGBXZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 19:25:47 -0400
Message-ID: <486C0ED0.3080608@lwfinger.net>
Date: Wed, 02 Jul 2008 18:27:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, debian-kernel@lists.debian.org,
       Giacomo Mulas <gmulas@ca.astro.it>,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
       linux-kernel@vger.kernel.org
Subject: Re: b43 locks the machine when resuming after suspend to disk
References: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it>	<200807022340.31894.rjw@sisk.pl>	<1215039419.13270.18.camel@johannes.berg>	<200807030108.37614.rjw@sisk.pl> <1215040064.13270.20.camel@johannes.berg>
In-Reply-To: <1215040064.13270.20.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> On Thu, 2008-07-03 at 01:08 +0200, Rafael J. Wysocki wrote:
>> On Thursday, 3 of July 2008, Johannes Berg wrote:
>>> Rafael, you misled me :) This is a completely different thing.
>> Ah, sorry then.  I was too quick with my response.
> 
> No trouble, it reminded me that I wanted to ask stable to pick up that
> patch anyway although I don't think we ever ran into the issue there.
> 
> This seems very odd though, Giacomo, are you sure it also happens if you
> unload the module?

I'm confused. Should the "mac80211: detect driver tx bugs" patch be sent to stable?

Larry


