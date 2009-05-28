Return-Path: <linux-kernel-owner+w=401wt.eu-S1764145AbZE1VUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764145AbZE1VUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 17:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760302AbZE1VUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 17:20:03 -0400
Received: from windsormachine.com ([216.8.138.2]:35888 "EHLO
	router.windsormachine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbZE1VUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 17:20:01 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 May 2009 17:20:01 EDT
Message-ID: <4A1EFDAC.9050103@windsormachine.com>
Date: Thu, 28 May 2009 17:10:04 -0400
From: Mike Dresser <mdresser_l@windsormachine.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Mike Dresser <mdresser_l@windsormachine.com>,
       Alex Samad <alex@samad.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>, 526406@bugs.debian.org
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <20090525002210.GE1339@samad.com.au> <alpine.DEB.1.10.0905250032330.19424@router.windsormachine.com> <200905260115.56374.rjw@sisk.pl>
In-Reply-To: <200905260115.56374.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-scanner: Scanned by Xamime-LT 0.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should mention that I don't run NFS on this server, so it's likely not 
to be an NFS issue either.


