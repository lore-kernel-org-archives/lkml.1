Return-Path: <linux-kernel-owner+w=401wt.eu-S1765688AbZDBQiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765688AbZDBQiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765571AbZDBQhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:37:42 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:41110 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765529AbZDBQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:37:41 -0400
Message-ID: <49D4E968.1040704@oracle.com>
Date: Thu, 02 Apr 2009 09:35:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       andreas.herrmann3@amd.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29 boot hang
References: <49D280EF.1080507@oracle.com> <200904011703.58179.rusty@rustcorp.com.au> <49D3A4B6.2030409@oracle.com> <200904021112.57662.rusty@rustcorp.com.au>
In-Reply-To: <200904021112.57662.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49D4E970.005C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 02 April 2009 04:00:30 Randy Dunlap wrote:
>> 2.6.29 + this patch still hang during boot for me.  Same symptoms.
> 
> OK, thanks.  It's something new then.
> 
> We're down to inserting printks at this point.  Can you send me your
> .config so I can try to reproduce it on my AMD box here?
> 
> (I'm assuming that the latest Linus tree still doesn't boot, so it's not
> some incidental issue).

Sorry for the delay.  It's about a 50-50 chance of hanging in my limited
testing (3 successful boots, 3 hangs), using 2.6.29-git9.

-- 
~Randy
