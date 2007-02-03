Return-Path: <linux-kernel-owner+w=401wt.eu-S1946463AbXBCPc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946463AbXBCPc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 10:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992427AbXBCPc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 10:32:58 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58288 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946463AbXBCPc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 10:32:57 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45C4AAFA.3050208@s5r6.in-berlin.de>
Date: Sat, 03 Feb 2007 16:32:10 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Pieter Palmers <pieterp@joow.be>
CC: Dan Dennedy <dan@dennedy.org>, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] ieee1394: cycle timer read extension for	raw1394/libraw1394
References: <45BA5CFD.6070900@joow.be> <45BB27AF.7030007@s5r6.in-berlin.de>	<45BB2D67.7030608@joow.be> <45BB4A33.4070206@s5r6.in-berlin.de> <tkrat.e06f68103e99e517@s5r6.in-berlin.de> <45C49A88.4050809@joow.be>
In-Reply-To: <45C49A88.4050809@joow.be>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pieter Palmers wrote:
> Stefan Richter wrote:
...
>>   - Fix integer overflow.
> I had to use 1000000ULL instead of USEC_PER_SEC to avoid weird behavior.

OK, I'll change that and will wait for...

> I can't test it right now, but I'll report later.

...your and Dan's ACK before I commit the patch.
-- 
Stefan Richter
-=====-=-=== --=- ---==
http://arcgraph.de/sr/
