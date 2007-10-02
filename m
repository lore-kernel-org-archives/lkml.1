Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbXJBJrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbXJBJrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXJBJrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:47:09 -0400
Received: from mx1.caravan.ru ([217.23.130.2]:60270 "EHLO mx1.caravan.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbXJBJrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:47:08 -0400
Message-ID: <47021418.7040103@lxnt.info>
Date: Tue, 02 Oct 2007 13:49:12 +0400
From: Alexander Sabourenkov <screwdriver@lxnt.info>
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Clemens Koller <clemens.koller@anagramm.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Promise SATA300 TX4: errors, oops in ext3 code
References: <47009BF6.5000208@lxnt.info> <4700B966.1030508@anagramm.de> <4701CAA9.6070902@lxnt.info> <47020A9E.6090602@anagramm.de>
In-Reply-To: <47020A9E.6090602@anagramm.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Koller wrote:
> Okay, I have no idea about any bugs there.
> You have several options: Find a 100% working vanilla kernel for your
> problem (minimal configuration, skip i.e. the sound stuff, ...).
> And then git bisect with a known bad kernel.

I'm afraid there is no 100% working kernel. Problems were reported as 
far back as 2.6.11, and I never found a single thread in mailing lists 
ending with "problem solved" (not counting PSU and thermal issues).

> Same thing in hardware: move components (Controllers + HDD) to/from a 
> working
> machine and verify...

Unfortunately right now I have no yet-untested machine - both I have 
show same problems.


Time permitting I'll test 2.6.23 kernel, libata-dev branch, 
SATA300/SATA150 modes and agressive card cooling as you suggested in 
your other email and  document all this on a separate page or maybe a wiki.


-- 

./lxnt



