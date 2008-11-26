Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbYKZQnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbYKZQnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYKZQnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:43:04 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:48120 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYKZQnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:43:02 -0500
Message-ID: <492D7C55.4040909@oracle.com>
Date: Wed, 26 Nov 2008 08:41:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: eranian@googlemail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       eranian@gmail.com, sfr@canb.auug.org.au
Subject: Re: [patch 23/24] perfmon: kernel documentation
References: <492d0c14.02225e0a.15ab.6f8e@mx.google.com> <20081126122107.GV6703@one.firstfloor.org>
In-Reply-To: <20081126122107.GV6703@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.492D7C5A.01A4:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wed, Nov 26, 2008 at 12:43:00AM -0800, eranian@googlemail.com wrote:
> 
>> +
>> +    We have released a simple monitoring tool to demonstrate the features of
>> +    the interface. The tool is called pfmon and it comes with a simple helper
>> +    library called libpfm. The library comes with a set of examples to show
> 
> I don't think "simple" is the right word to describe pfmon/libpfm @)
> 
>> +    There maybe other tools available for perfmon.
> 
> s/maybe/are/ ?

If not "are", then it at least should be changed to "may be".


-- 
~Randy
