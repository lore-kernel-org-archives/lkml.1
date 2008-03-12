Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbYCLQBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbYCLQBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYCLQB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:01:26 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:42601 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYCLQBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:01:25 -0400
Message-ID: <47D7FE4D.5090107@s5r6.in-berlin.de>
Date: Wed, 12 Mar 2008 17:01:17 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] firewire: debug AT, AR, and selfID-complete events
References: <tkrat.f96c4067f6a48f4a@s5r6.in-berlin.de>	<tkrat.ebca3f78fa768606@s5r6.in-berlin.de>	<47D79F3E.60803@s5r6.in-berlin.de> <200803121034.39583.jwilson@redhat.com>
In-Reply-To: <200803121034.39583.jwilson@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> Want to do that as a later follow-up patch, or roll it into this one and post 
> another update?

I haven't committed to linux1394-2.6.git, hence I prefer to post an
update rather than incremental patch.

> (I'm fully prepared to sign off on either way after having 
> extensively used these patches the past several days...)

BTW, if I get sign-offs/ acks/ test feedback on a patch before another
patch update (but not before committing the final version to the
upstream submission branch), I add those sign-offs etc. like this

    S-o-b: Someone
    S-o-b: Me (modified whitespace or something else trivial)

or this

    Initial changelog

    S-o-b: Someone

    Changelog post scriptum

    S-o-b: Me

provided that the update only marginally changes the patch or can be
clearly distinguished from the formerly signed off parts.  Of course if
I get sign-offs etc. on the final version of the patch
-- 
Stefan Richter
-=====-==--- --== -==--
http://arcgraph.de/sr/
