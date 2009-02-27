Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbZB0Snx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbZB0Snx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZB0Snp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:43:45 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:46767 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbZB0Sno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:43:44 -0500
Message-ID: <49A834A3.5000302@oracle.com>
Date: Fri, 27 Feb 2009 10:44:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bart Trojanowski <bart@jukie.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: where is Documentation/REPORTING-BUGS ?
References: <20090227183326.GC23376@jukie.net>
In-Reply-To: <20090227183326.GC23376@jukie.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49A83455.0168:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Trojanowski wrote:
> I ran into a regression in 2.6.28..2.6.29-rc6 in vlan code.  I am
> bisecting it right now.
> 
> While that happens, I wanted to check if the proper way to report it is:
> via bugzilla or email.  I went to Documentation and looked for related
> material.
> 
> From Documentation/BUG-HUNTING...
>> Before you submit a bug report read REPORTING-BUGS.
> 
> I'd love to, but it's not there.

It's in the top-level of the kernel tree, not in the Documentation/
directory.

> The only thing I can find is text from 2003, that predates bugzilla.k.o.
> 
>         http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html
> 
> If that is still official, maybe it could make its way back into the git
> tree.  If not, what's today's preferred bug reporting method?



-- 
~Randy
