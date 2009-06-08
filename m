Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZFHWau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZFHWau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 18:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZFHWah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 18:30:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53272 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbZFHWag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 18:30:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A2D90EB.4070005@s5r6.in-berlin.de>
Date: Tue, 09 Jun 2009 00:30:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David VomLehn <dvomlehn@cisco.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 3/7] initdev:kernel:Await console discovery, v6
References: <20090606023407.GA5695@cuplxvomd02.corp.sa.net> <4A2A2EED.3060506@s5r6.in-berlin.de> <20090608221344.GB22222@cuplxvomd02.corp.sa.net>
In-Reply-To: <20090608221344.GB22222@cuplxvomd02.corp.sa.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn wrote:
> On Sat, Jun 06, 2009 at 04:55:09AM -0400, Stefan Richter wrote:
>> David VomLehn wrote:
...
>>> v3.2	Use only a single new command line parameter by adding the possible
>>> 	value "forever".  Add message specifying the parameter to modify to
>>> 	increase the delay for console initialization
>>> v3.1	Correct the abbreviation for milliseconds in
>>> 	Documentation/kernel-parameters.txt to be "ms", not "mS". Thanks to
...
>>> ---
>>>  drivers/accessibility/braille/braille_console.c |    2 +
>>>  kernel/printk.c                                 |   29 ++++++++++++++++++++++-
>>>  2 files changed, 30 insertions(+), 1 deletions(-)
>> Is this diff complete?
> 
> To the best of my knowledge, yes, it is complete. What makes it look as though
> it might not be?

The history notes.
kernel-parameters.txt, new command line parameter...
-- 
Stefan Richter
-=====-==--= -==- -=--=
http://arcgraph.de/sr/
