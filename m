Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbZLDUgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbZLDUgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757247AbZLDUgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:36:06 -0500
Received: from [83.170.124.135] ([83.170.124.135]:52658 "EHLO
	pluto.daelnet.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757244AbZLDUgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:36:05 -0500
Message-ID: <4B1972B6.1060408@cybus.co.uk>
Date: Fri, 04 Dec 2009 20:36:06 +0000
From: Jonathan Miles <jon@cybus.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, David John <davidjon@xenontk.org>,
       penberg@cs.helsinki.fi
Subject: Re: OOM kernel behaviour - 2.6.32
References: <4B1402FC.80307@cybus.co.uk> <alpine.DEB.2.00.0911301253410.18682@router.home> <4B14E8A2.4020500@cybus.co.uk> <alpine.DEB.2.00.0912010949400.8841@router.home> <4B155B4A.9050405@cybus.co.uk>
In-Reply-To: <4B155B4A.9050405@cybus.co.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/09 18:07 Jonathan Miles said the following:

> It's Ubuntu's (Karmic) 2.6.31 .deb and I don't know exactly what they've
> done to it, but AFAIK, no containers or policies. I'll compile 2.6.31.6
> and test with that. Won't be able to do this until Friday, so will check
> back in then.

Everything is fine having compiled straight 2.6.32. I watched the cache
being reclaimed with top as I used more and more RAM and didn't see the
OOM killer being invoked. So it was either a problem with 2.6.31 or with
whatever Ubuntu did to make the .deb.

Thanks,

-- 
Jonathan Miles <jon@cybus.co.uk>
http://www.linkedin.com/in/jonmiles

