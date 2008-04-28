Return-Path: <linux-kernel-owner+w=401wt.eu-S1765428AbYD1GMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765428AbYD1GMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYD1GMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:12:06 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40114 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbYD1GMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:12:05 -0400
Date: Mon, 28 Apr 2008 02:11:59 -0400 (EDT)
From: Jeff Arnold <jbarnold@MIT.EDU>
To: linux-kernel@vger.kernel.org
Subject: Re: A system for rebootless kernel security updates
In-Reply-To: <200804242116.54019.mail@earthworm.de>
Message-ID: <alpine.DEB.1.10.0804272022560.15570@vinegar-pot.mit.edu>
References: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu> <200804241543.06874.mail@earthworm.de> <alpine.DEB.1.00.0804241306260.21001@vinegar-pot.mit.edu> <200804242116.54019.mail@earthworm.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Apr 2008, Christian Hesse wrote:
> This time I get the following in syslog:

This problem has now been resolved (a broken wireless card apparently left 
a kernel thread in an unusual state, which led to Ksplice aborting the 
upgrade).  Christian now has Ksplice working on his system.

If anyone else tries the software and encounters trouble, please let me 
know.

Thanks,

Jeff Arnold
jbarnold@mit.edu
