Return-Path: <linux-kernel-owner+w=401wt.eu-S1762988AbYAaPyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762988AbYAaPyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757173AbYAaPyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:54:41 -0500
Received: from trinity.phys.uwm.edu ([129.89.57.159]:50280 "EHLO
	trinity.phys.uwm.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbYAaPyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:54:40 -0500
Date: Thu, 31 Jan 2008 09:54:26 -0600 (CST)
From: Bruce Allen <ballen@gravity.phys.uwm.edu>
X-X-Sender: ballen@trinity.phys.uwm.edu
To: Bill Fink <billfink@mindspring.com>
cc: SANGTAE HA <sangtae.ha@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: e1000 full-duplex TCP performance well below wire speed
In-Reply-To: <20080131064533.ef0ae932.billfink@mindspring.com>
Message-ID: <Pine.LNX.4.63.0801310951060.10967@trinity.phys.uwm.edu>
References: <Pine.LNX.4.63.0801300324000.6391@trinity.phys.uwm.edu>
 <20080130.055333.192844925.davem@davemloft.net>
 <Pine.LNX.4.63.0801300758020.11487@trinity.phys.uwm.edu>
 <20080130082136.1017631d@deepthought> <Pine.LNX.4.63.0801301610240.19938@trinity.phys.uwm.edu>
 <649aecc70801301617m6331bcb8i8ce60366e182c739@mail.gmail.com>
 <20080131064533.ef0ae932.billfink@mindspring.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill,

> I see similar results on my test systems

Thanks for this report and for confirming our observations.  Could you 
please confirm that a single-port bidrectional UDP link runs at wire 
speed?  This helps to localize the problem to the TCP stack or interaction 
of the TCP stack with the e1000 driver and hardware.

Cheers,
 	Bruce
