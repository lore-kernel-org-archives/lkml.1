Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZBSSR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZBSSR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZBSSRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:17:19 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:61467 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZBSSRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:17:18 -0500
Message-ID: <499DA235.6090700@oracle.com>
Date: Thu, 19 Feb 2009 10:17:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] eeepc: needs to depend on INPUT
References: <20090220002832.cad00fcd.sfr@canb.auug.org.au>	 <499D93F0.2090803@oracle.com> <71cd59b00902191012k764bab32n85f54fc049e35035@mail.gmail.com>
In-Reply-To: <71cd59b00902191012k764bab32n85f54fc049e35035@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.499DA201.00E9:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corentin Chary wrote:
> On Thu, Feb 19, 2009 at 6:16 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> EEEPC_LAPTOP needs to depend on INPUT to fix build errors that
>> can happen when EEEPC_LAPTOP=y and INPUT=m:
> 
> There is already a patch sent to linux-acpi and Len Brown.
> 
> http://patchwork.kernel.org/patch/7354/

Today's linux-next doesn't build (doesn't have that patch).  :(

-- 
~Randy
