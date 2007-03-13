Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbXCMSyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbXCMSyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbXCMSyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:54:06 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:47923 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932566AbXCMSyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:54:05 -0400
Date: Tue, 13 Mar 2007 14:54:05 -0400
To: Mark Lord <lkml@rtr.ca>
Cc: Phil Kaslo <phil@cs.arizona.edu>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Asus P5B-VM motherboard:  cd drive malfunctions if internal nic in use.
Message-ID: <20070313185405.GI22464@csclub.uwaterloo.ca>
References: <200703122212.l2CMCaxm032601@osprey.cs.arizona.edu> <45F5D59E.10304@rtr.ca> <20070313153252.GC22466@csclub.uwaterloo.ca> <45F6CFEA.4060009@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6CFEA.4060009@rtr.ca>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 12:23:06PM -0400, Mark Lord wrote:
> That's nice.
> 
> But the P5B-VM board does not have any such jumper for USB,
> nor does it have any obvious combination of BIOS-setup options
> to accomplish it.

Well it could only be done by hardware.  The P5B has those jumpers.  I
figured the P5B-VM while a budget micro board would still have those.  I
guess not.  Without jumper settings for it there is nothing you can do
about it.  A quick look through the manual certainly only mentions
standby power for the keyboard connector and not for the USB ports.

--
Len Sorensen
