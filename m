Return-Path: <linux-kernel-owner+w=401wt.eu-S1760640AbYDCBBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760640AbYDCBBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbYDCBB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:01:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:11747 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbYDCBB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:01:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PQ2AqhrPHEjTAHQFDGX4XEX4EiWAoUrjgfpaZ4yZv9BMNWz2WMAMougNl2PyQooe6j7Yg+eG28B6UfvQDqin2o73HmB1GsYKcwc4I6gbDsYNUSqyffR8yA8pnzIYLxDDmwk57PRg1MX9KPJoDPER0lPy9Pj5bUUFeSvqWbW8+Tw=
Message-ID: <47F42C5F.6090003@gmail.com>
Date: Thu, 03 Apr 2008 10:01:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: suspend
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com>	 <200804021419.06672.rjw@sisk.pl>	 <dd18b0c30804020853w50e0290cy8b0303e30f2bcfec@mail.gmail.com>	 <200804021939.46733.rjw@sisk.pl>	 <dd18b0c30804021218t700484faua57a46e237ea581f@mail.gmail.com>	 <47F42259.8030603@gmail.com> <dd18b0c30804021744m67fe4db4m8aed3897945baaa8@mail.gmail.com>
In-Reply-To: <dd18b0c30804021744m67fe4db4m8aed3897945baaa8@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> Hello; attached is kern.log as asked and lspci -nn.

kernel log is missing.

> I've noticed some avc's in there. makes me wonder if this is why
> wpa_supplicant isnt working after a wakeup

Probably not.  It just took one extra try to wake the device up.  Both 
hard and optical drives are accessible after resume, right?

-- 
tejun
