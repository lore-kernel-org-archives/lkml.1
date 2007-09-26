Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbXIZCqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbXIZCqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 22:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbXIZCqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 22:46:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41025 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbXIZCp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 22:45:59 -0400
Message-ID: <46F9C7DE.8000604@pobox.com>
Date: Tue, 25 Sep 2007 22:45:50 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       roel <12o3l@tiscali.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 1/2] Enable link power management for ata drivers
References: <20070924215140.966161778@intel.com>	<20070924151320.67f0c332.kristen.c.accardi@intel.com>	<46F84460.5090703@tiscali.nl>	<20070924164118.803cfb22.kristen.c.accardi@intel.com>	<46F84F45.6000807@pobox.com> <20070925105025.0cb9cc37@the-village.bc.nu>
In-Reply-To: <20070925105025.0cb9cc37@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> It converts several macros to inline functions (encouraged), and also 
>> illustrates a nice, clean way of testing an ID word's validity. 
>> [obviously the final implementation varies, depending on that ID word's 
>> history]
> 
> Its in -mm and I thought you put a copy in your tree after I said it
> hadn't upset anything in -mm ?

it didn't apply straightaway to my tree for whatever reason, IIRC


