Return-Path: <linux-kernel-owner+w=401wt.eu-S936533AbXFGAJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936533AbXFGAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935531AbXFGAJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:09:47 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:4543 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821AbXFGAJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:09:46 -0400
Date: Wed, 06 Jun 2007 18:09:12 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC][PATCH] Re: 4Gb ram not showing up
In-reply-to: <fa.v/tV4BtD9VBbszRCBALGEBt2uUw@ifi.uio.no>
To: Andrew Lyon <andrew.lyon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46674CA8.1090700@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.KfNZpadRG0eZUXpSEPaw6ru0bsI@ifi.uio.no>
 <fa.onZVzrCKi+mc+cmivZh4BhVROlY@ifi.uio.no>
 <fa./NQsJ0P5QQw7SMr++Q5kkRcAJHs@ifi.uio.no>
 <fa.v/tV4BtD9VBbszRCBALGEBt2uUw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lyon wrote:
> Could this also cause a system to be unstable? my abit athlon64 at
> work will not run x64 with more than 1gb ram, and i have a colo server
> with supermicro & 2 x dual core xeons that will not run with more than
> 2gb.
> 
> Both systems have long uptimes but if i add ram they crash within
> minutes of booting.
> 
> Tried several kernels up to 2.6.21 and gave up, I can send dmesg
> output but the crashes are completely random.

That is likely some other problem, like bad RAM or memory timing issues.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

