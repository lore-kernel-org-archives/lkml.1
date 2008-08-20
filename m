Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYHTUlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYHTUlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbYHTUll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:41:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56433 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbYHTUlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:41:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48AC8167.1020302@s5r6.in-berlin.de>
Date: Wed, 20 Aug 2008 22:41:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux1394-devel@lists.sourceforge.net, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: new driver staged in linux1394-2.6.git
References: <tkrat.51b6249bb700fa85@s5r6.in-berlin.de> <20080820201106.GC10526@kroah.com>
In-Reply-To: <20080820201106.GC10526@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Aug 20, 2008 at 12:27:40AM +0200, Stefan Richter wrote:
>> I have harvested the respective patches from Greg KH's staging tree and
>> added two further updates; more to be added soon.
> 
> Very nice, thanks for picking this up.
> 
> Should I drop it from my -staging tree now so that people know to work
> off of your version?

Yes, since I hope we will get it -next-worthy in linux1394-2.6.git soon.

> This assumes that it will not be dropped by you :)

I'll carry it until mainline merge, unless bigger subsystem changes 
happen on the v4l-dbv front that make it necessary to move it to their repo.
-- 
Stefan Richter
-=====-==--- =--- =-=--
http://arcgraph.de/sr/
