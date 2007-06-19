Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbXFSPH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbXFSPH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbXFSPHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:07:46 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:28959 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753780AbXFSPHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:07:45 -0400
Message-ID: <4677F14A.5060909@cfl.rr.com>
Date: Tue, 19 Jun 2007 11:07:54 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: david@lang.hm
CC: Brendan Conoboy <blc@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
References: <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jun 2007 15:07:54.0435 (UTC) FILETIME=[9CCAE130:01C7B283]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15248.000
X-TM-AS-Result: No--8.062400-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> one channel, 2 OS drives plus the 45 drives in the array.

Huh?  You can only have 16 devices on a scsi bus, counting the host 
adapter.  And I don't think you can even manage that much reliably with 
the newer higher speed versions, at least not without some very special 
cables.

> yes I realize that there will be bottlenecks with this, the large 
> capacity is to handle longer history (it's going to be a 30TB circular 
> buffer being fed by a pair of OC-12 links)

Building one of those nice packet sniffers for the NSA to install on 
AT&Ts network eh? ;)


