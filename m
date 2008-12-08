Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYLHTO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYLHTO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 14:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYLHTOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 14:14:48 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52759 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYLHTOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 14:14:48 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <493D720A.7020503@s5r6.in-berlin.de>
Date: Mon, 08 Dec 2008 20:14:18 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Holger Hoffstaette <holger@wizards.de>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, stable@kernel.org
Subject: Re: Nasty regression from .27.7 to .27.8: idle samba goes crazy
References: <pan.2008.12.08.06.18.57.357875@wizards.de> <200812080834.22924.rjw@sisk.pl> <493D4C1B.4030006@s5r6.in-berlin.de> <200812081946.50295.rjw@sisk.pl>
In-Reply-To: <200812081946.50295.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 8 of December 2008, Stefan Richter wrote:
>> Rafael J. Wysocki wrote:
>>> Please bisect.
>> Why should he bisect before the developers who added networking related
>> patches to .8 attempted to reproduce the bug, let alone looked at the
>> report?
> 
> Because I think that's the fastest way to turn the attention of the appropriate
> people to the problem.

All the contributors to 2.6.27.8 are known by name & address, and they
hopefully remember what they put into .8 and can quickly tell whether
there is a chance that it could have something to do with Samba going
into an unkillable busy loop.

So, in case of a bug report which even includes a potential way to
reproduce the issue on generic hardware with common tools, "Could you
bisect?  Meanwhile, let's Cc netdev." sounds better to me than "Please
bisect."
-- 
Stefan Richter
-=====-==--- ==-- -=---
http://arcgraph.de/sr/
