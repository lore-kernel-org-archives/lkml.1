Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbYKWTjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbYKWTjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYKWTjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:39:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55993 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYKWTjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:39:08 -0500
To: Jeff Arnold <jbarnold@MIT.EDU>
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, davem@davemloft.net, mhiramat@redhat.com,
       contact@ksplice.com, jbarnold@ksplice.com, tabbott@ksplice.com,
       wdaher@ksplice.com, andersk@ksplice.com
Subject: Re: [RFC] kreplace: Rebootless kernel updates
From: Andi Kleen <andi@firstfloor.org>
References: <200811211720.26394.knikanth@suse.de>
	<alpine.DEB.2.00.0811211303460.24014@vinegar-pot.mit.edu>
Date: Sun, 23 Nov 2008 20:39:10 +0100
In-Reply-To: <alpine.DEB.2.00.0811211303460.24014@vinegar-pot.mit.edu> (Jeff Arnold's message of "Fri, 21 Nov 2008 22:46:59 -0500 (EST)")
Message-ID: <87myfqi65d.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Arnold <jbarnold@MIT.EDU> writes:

> Hello,
>
>> [kreplace] is currently a x86_64 only _hack_
>
> The point of Ksplice is to be a hot update system that isn't a hack.  
> Ksplice is quite far along at this point; it implements many safety and 
> automation features that kreplace doesn't address.  Is there something in 
> particular that discouraged you from using Ksplice?

I suspect that it wasn't mainline?

The usual problem is that it's much easier to get simple patches
in than complicated ones.

-Andi

-- 
ak@linux.intel.com
