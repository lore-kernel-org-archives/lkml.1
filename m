Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbYKWUxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbYKWUxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYKWUxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 15:53:35 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43622 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867AbYKWUxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 15:53:34 -0500
Date: Sun, 23 Nov 2008 15:53:03 -0500 (EST)
From: Jeff Arnold <jbarnold@MIT.EDU>
To: Andi Kleen <andi@firstfloor.org>
cc: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, davem@davemloft.net, mhiramat@redhat.com,
       contact@ksplice.com, jbarnold@ksplice.com, tabbott@ksplice.com,
       wdaher@ksplice.com, andersk@ksplice.com
Subject: Re: [RFC] kreplace: Rebootless kernel updates
In-Reply-To: <87myfqi65d.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.2.00.0811231442170.4729@vinegar-pot.mit.edu>
References: <200811211720.26394.knikanth@suse.de> <alpine.DEB.2.00.0811211303460.24014@vinegar-pot.mit.edu> <87myfqi65d.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I suspect that it wasn't mainline?

OK.  We're aware of that problem and are working on it ;)

> The usual problem is that it's much easier to get simple patches
> in than complicated ones.

Right.  Unfortunately, if you make a hot update system's design too 
simple, it can be dangerous and will potentially do more harm than good.

If there's anything that I can do to help people understand our code and 
why we think that it's as simple as you'd want a hot update system to be, 
please let me know.

Jeff Arnold
jbarnold@mit.edu
