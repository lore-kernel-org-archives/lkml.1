Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYLaWCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYLaWCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYLaWCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:02:25 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48269 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbYLaWCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:02:24 -0500
Date: Wed, 31 Dec 2008 16:59:39 -0500 (EST)
From: Tim Abbott <tabbott@MIT.EDU>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
cc: Jeff Arnold <jbarnold@MIT.EDU>, linux-kernel@vger.kernel.org,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH 1/7] Make section names compatible with -ffunction-sections
 -fdata-sections
In-Reply-To: <20081231195215.GU496@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.0812311649180.2230@vinegar-pot.mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-2-git-send-email-jbarnold@mit.edu> <8763lxwv0d.fsf@basil.nowhere.org> <alpine.DEB.2.00.0812311410070.2230@vinegar-pot.mit.edu> <20081231195215.GU496@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I'd like to get this -ffunction-sections patch merged sometime during the 
2.6.29 merge window.  I've updated it in my git repository to work on top 
of Linus' current master; how do you want to handle this?

Thanks,

 	-Tim Abbott

