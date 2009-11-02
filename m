Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZKBQO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZKBQO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbZKBQO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:14:28 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43333 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168AbZKBQO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:14:27 -0500
Message-ID: <4AEF0562.3020208@austin.ibm.com>
Date: Mon, 02 Nov 2009 10:14:26 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6 v5] Memory probe/release files
References: <4AE8ADCF.6090104@austin.ibm.com>	 <4AE8AFDD.6030504@austin.ibm.com> <1256786013.26770.40.camel@pasglop>
In-Reply-To: <1256786013.26770.40.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Wed, 2009-10-28 at 15:55 -0500, Nathan Fontenot wrote:
>> This patch creates the release sysfs file for memory and updates the
>> exisiting probe file so both make arch-specific callouts to handle removing
>> and adding memory to the system.  This also creates the powerpc specific stubs
>> for handling the arch callouts.
>>
>> The creation and use of these files are governed by the exisitng
>> CONFIG_ARCH_MEMORY_PROBE and new CONFIG_ARCH_MEMORY_RELEASE config options.
>>
>> Signed-off-by: Nathan Fontenot <nfont at austin.ibm.com>
>> ---
> 
> Is there anybody on linux-mm who needs to Ack this patche ?

Not sure.  I will cc linux-mm on the next set of updated patches I send out.

-Nathan

> 
> Cheers,
> Ben.
> 
> 
> 
