Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbZCaVzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbZCaVzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbZCaVz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:55:28 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:32017 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbZCaVz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:55:28 -0400
Message-ID: <49D29122.6060601@oracle.com>
Date: Tue, 31 Mar 2009 14:54:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Morten P.D. Stevens" <mstevens@win-professional.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, andreas.herrmann3@amd.com
Subject: Re: 2.6.29 boot hang
References: <49D280EF.1080507@oracle.com> <897274600903311401v65fe3d3ame8522226a8a71ca9@mail.gmail.com>
In-Reply-To: <897274600903311401v65fe3d3ame8522226a8a71ca9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.49D2912D.010D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Morten P.D. Stevens wrote:
> 2009/3/31 Randy Dunlap <randy.dunlap@oracle.com>:
> 
>> If I change CONFIG_MICROCODE_AMD=y to CONFIG_MICROCODE_AMD=n & rebuild,
>> the kernel boots successfully.
>>
>> Suggestions, fixes, etc.??
>>
> 
> Does it boot with 2.6.28 and CONFIG_MICROCODE_AMD=y ?

Good question.  I hadn't tested that explicitly, but I have now.

Yes (for 2.6.28.1).

> If it is booting with 2.6.28 and AMD=y it could be a linux kernel
> related problem.

Thanks.
-- 
~Randy
