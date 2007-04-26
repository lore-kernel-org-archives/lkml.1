Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbXDZGTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbXDZGTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbXDZGTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:19:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:63271 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbXDZGTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:19:34 -0400
Message-ID: <46304503.4060505@oracle.com>
Date: Wed, 25 Apr 2007 23:21:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: [PATCH -mm] x86_64: kill 19000+ sparse warnings
References: <20070425224509.46153baa.randy.dunlap@oracle.com>	<20070425225516.8b573d34.akpm@linux-foundation.org>	<463041BC.8000708@oracle.com> <20070425231452.929acac0.akpm@linux-foundation.org>
In-Reply-To: <20070425231452.929acac0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 25 Apr 2007 23:07:56 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> oh.  there is already an include/asm-x86_64/const.h that will help
>> with that.  I'll try it out.
> 
> No there isn't ;)  There's a sparc64 one which looks good.  Worth promoting
> to include/linux?

Did you look in -mm?  I did.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
