Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYHVMiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYHVMiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYHVMiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:38:07 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:39397 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYHVMiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:38:06 -0400
Message-ID: <48AEB2D8.7000304@s5r6.in-berlin.de>
Date: Fri, 22 Aug 2008 14:36:40 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: Nick Piggin <nickpiggin@yahoo.com.au>, paulmck@linux.vnet.ibm.com,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger  2.6.27-rc4  
    released
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>    <200808212337.38626.nickpiggin@yahoo.com.au>    <48AD7705.2000404@s5r6.in-berlin.de>    <200808221140.25029.nickpiggin@yahoo.com.au>    <tkrat.28e983dc4d04d109@s5r6.in-berlin.de> <42930.166.70.238.46.1219406040.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <42930.166.70.238.46.1219406040.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
[rlock->flags in debug_lock(), debug_unlock()]
> since this case only
> occurs when two processors both have an int1 exception (or some exception
> other than an NMI) and ints are disabled here anyway, its benign.

Ah, thanks.  I missed the bigger picture.
-- 
Stefan Richter
-=====-==--- =--- =-==-
http://arcgraph.de/sr/
