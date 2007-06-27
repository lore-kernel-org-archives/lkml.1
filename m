Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbXF0G0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbXF0G0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbXF0G0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:26:33 -0400
Received: from sccrmhc11.comcast.net ([63.240.77.81]:57828 "EHLO
	sccrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbXF0G0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:26:33 -0400
Message-ID: <46820316.7070406@ringle.org>
Date: Wed, 27 Jun 2007 02:26:30 -0400
From: Jon Ringle <jon@ringle.org>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jon Ringle <JRingle@vertical.com>, linux-kernel@vger.kernel.org
Subject: Re: scheduling while atomic and DEBUG_SPINLOCK_SLEEP
References: <4DD3AF7ECBBC43409BA36508938D01851B0E7E@CVAEX1.VERTICAL.COM> <1182919609.3201.2.camel@laptopd505.fenrus.org>
In-Reply-To: <1182919609.3201.2.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 2007-06-26 at 22:55 -0400, Jon Ringle wrote:
>   
>> Hello,
>> Out of these two, the first one that is showing "in_atomic():1" seems
>> more likely to me to be a potential cause of the "scheduling while
>> atomic" dump.
>>
>> Does this logic seem reasonable? Are there other debugging techniques I
>> can use to narrow down the cause for the "scheduling while atomic"?
>>     
>
>
> you could start by giving us pointers to the sources of the two
> drivers... without that... how can we look and help?
>
>   
You can get Intel's source from here:
GPL_ixp400LinuxEthernetDriverPatch-1_5.zip:
http://downloadcenter.intel.com/detail_desc.aspx?agr=N&ProductID=2100&DwnldID=9519

BSD_ixp400AccessLibrary-2_1.zip:
http://downloadfinder.intel.com/scripts-df/detail_desc.asp?agr=Y&ProductID=2100&DwnldID=10146

Jon
