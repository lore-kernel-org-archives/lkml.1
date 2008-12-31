Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbYLaTWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbYLaTWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYLaTWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:22:25 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58511 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448AbYLaTWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:22:24 -0500
Date: Wed, 31 Dec 2008 14:18:43 -0500 (EST)
From: Tim Abbott <tabbott@MIT.EDU>
To: Andi Kleen <andi@firstfloor.org>
cc: Jeff Arnold <jbarnold@MIT.EDU>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH 1/7] Make section names compatible with -ffunction-sections
 -fdata-sections
In-Reply-To: <8763lxwv0d.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.2.00.0812311410070.2230@vinegar-pot.mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-2-git-send-email-jbarnold@mit.edu> <8763lxwv0d.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Dec 2008, Andi Kleen wrote:

> It's quite large and touches a lot of code, so it probably would require 
> special treatment during a merge window to avoid conflicts.

OK.  How does special treatment during the merge window work?  Is it too 
late to get this patch scheduled during the present merge window?

 	-Tim Abbott
