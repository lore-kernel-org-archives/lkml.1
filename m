Return-Path: <linux-kernel-owner+w=401wt.eu-S932945AbZINSWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945AbZINSWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932930AbZINSWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:22:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51643 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931AbZINSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:22:14 -0400
Message-ID: <4AAE89CE.2030804@austin.ibm.com>
Date: Mon, 14 Sep 2009 13:22:06 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] kernel handling of dynamic logical partitioning
References: <4AAABC55.4070207@austin.ibm.com> <1252704198.28368.31.camel@desktop>
In-Reply-To: <1252704198.28368.31.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Fri, 2009-09-11 at 16:08 -0500, Nathan Fontenot wrote:
>>  am cc'ing lkml.
>>
>> Patches include in this set:
>> 1/5 - DLPAR infrastructure for powerpc/pseries platform.
>> 2/5 - Move the of_drconf_cell struct to prom.h
>> 3/5 - Export the memory sysdev class
>> 4/5 - Memory DLPAR handling
>> 5/5 - CPU DLPAR handling
>>
> 
> It looks like a couple of your patches have some checkpatch issues..
> Could you run these through scripts/checkpatch.pl and clean up any
> problems it raises ? Specifically patches 1, 4, and 5 ..
> 

thanks for checking this, I obviously forgot.  I'll post updated patches
(after running checkpatch on them) with fixes.

-Nathan
