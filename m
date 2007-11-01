Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbXKAKjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbXKAKjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXKAKjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:39:41 -0400
Received: from grex.cyberspace.org ([216.86.77.194]:19055 "EHLO
	grex.cyberspace.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbXKAKjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:39:40 -0400
Date: Thu, 1 Nov 2007 06:39:39 -0400
From: Roopesh <roopesh@cyberspace.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Roopesh <roopesh@cyberspace.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: MMC: CRC Errors with 2GB cards
Message-ID: <20071101103939.GA28451@grex.cyberspace.org>
References: <20071019161700.GA19254@grex.cyberspace.org> <20071027140017.41e9d67f@poseidon.drzeus.cx> <20071029095015.GA20714@grex.cyberspace.org> <20071031205558.4507a2f0@poseidon.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031205558.4507a2f0@poseidon.drzeus.cx>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

:---------- Original Message ----------
:From:  Pierre Ossman [drzeus-list@drzeus.cx]
:Sent:  Wed, Oct 31, 2007 at 03:55:58PM EDT
:
:     Odd. I have a whole bunch of transcend cards, and I've
:     never gotten this problem. Perhaps yours are rather recent?
:     

  Though these cards were purchased only in last month, the 
  manufactring date (in cid) is shown to be 3-2007. Here are the 
  entire CID fields:

  manfid:28, product_name:SDC  , serial=5332, oemid=21334, 
  month-year=3-2007, hw-fw_rev=1-0

  / # cat /sys/bus/mmc/devices/mmc0\:b368/cid
  1c5356534443202010000014d400737d

  Thanks and Regards,
  Roopesh Keeppattu.
