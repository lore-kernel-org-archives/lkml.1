Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbYLaTi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbYLaTi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbYLaTit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:38:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48357 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYLaTis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:38:48 -0500
Date: Wed, 31 Dec 2008 20:52:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Andi Kleen <andi@firstfloor.org>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH 1/7] Make section names compatible with -ffunction-sections -fdata-sections
Message-ID: <20081231195215.GU496@one.firstfloor.org>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-2-git-send-email-jbarnold@mit.edu> <8763lxwv0d.fsf@basil.nowhere.org> <alpine.DEB.2.00.0812311410070.2230@vinegar-pot.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0812311410070.2230@vinegar-pot.mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 02:18:43PM -0500, Tim Abbott wrote:
> On Sat, 6 Dec 2008, Andi Kleen wrote:
> 
> >It's quite large and touches a lot of code, so it probably would require 
> >special treatment during a merge window to avoid conflicts.
> 
> OK.  How does special treatment during the merge window work?  

You negotiate a suitable time with Andrew/Linus in advance. This is typically
after all other trees got in.

> Is it too late

Probably not, as long as you can update the patch quickly enough.

-Andi
-- 
ak@linux.intel.com
