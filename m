Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbYAXWDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbYAXWDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYAXWD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:03:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42790 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbYAXWD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:03:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 24 Jan 2008 23:02:18 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch 07/26] Add INIT_ARRAY() to kernel.h
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080124210431.GA1647@Krystal>
Message-ID: <tkrat.234abd01d9726428@s5r6.in-berlin.de>
References: <20080124202706.250598537@polymtl.ca>
 <20080124203335.082459062@polymtl.ca>
 <20080124125845.bf5767b8.randy.dunlap@oracle.com>
 <20080124210431.GA1647@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 Jan, Mathieu Desnoyers wrote:
> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
>> Maybe you have explained this previously, but please give a short
>> explanation of "brackets that would pollute kernel code".
>> 
>> Thanks.
>> 
> 
> Try opening such code in vim, and the syntax highlighting gets all
> messed up :-/
> 
> The other option is to do the *right thing* and fix vim, of course, but
> this change won't be in distros for a while.

Is it about unbalanced brackets?

Anyway, if you add it because other kinds of initializers (which ones?)
aren't displayed nicely in syntax highlighting editors, just say so in
the changelog.  Your log isn't informative at all.
-- 
Stefan Richter
-=====-==--- ---= ==---
http://arcgraph.de/sr/

