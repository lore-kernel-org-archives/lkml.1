Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZLAOLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZLAOLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZLAOLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:11:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:35249 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbZLAOLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:11:43 -0500
Message-ID: <4B152424.1080101@suse.cz>
Date: Tue, 01 Dec 2009 15:11:48 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.3 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tarkan Erimer <tarkane@netone.com.tr>
Cc: Bernd Petrovitsch <bernd@firmix.at>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux-2.6.32-rc8-git2 Fails To Compile With GCC-4.4.2
References: <4B14FB56.4040608@netone.com.tr>	 <1259666631.23038.7.camel@tara.firmix.at>  <4B15006C.2020207@netone.com.tr> <1259667823.23038.9.camel@tara.firmix.at> <4B15029D.8090105@netone.com.tr>
In-Reply-To: <4B15029D.8090105@netone.com.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1.12.2009 12:48, Tarkan Erimer wrote:
> On 12/01/2009 01:43 PM, Bernd Petrovitsch wrote:
>>
>> Just to make sure: I meant OpenSUSEs bug tracker since you produced the
>> error with OpenSUSEs gcc.
>>
>> 	Bernd
>>   
> Ah, thanks for the warning. I was,almost, filing the bug report to GCC's
> bugzilla! ;-)

BTW, It was already reported and fixed: https://bugzilla.novell.com/558005 .

Michal
