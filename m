Return-Path: <linux-kernel-owner+w=401wt.eu-S1030606AbXAZOrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030606AbXAZOrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030638AbXAZOrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:47:01 -0500
Received: from mail.netilla.com ([63.97.64.130]:2051 "EHLO
	aep-us-dc-01.aep-net.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030606AbXAZOrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:47:01 -0500
Message-ID: <45BA148F.9080309@aepnetworks.com>
Date: Fri, 26 Jan 2007 09:47:43 -0500
From: Fei Liu <feiliu@aepnetworks.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060913)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: linux i386 kernel 2.4.16 2.4.22 scheduling issue?
References: <fa.vvOWc9w2lXOSM85ZYU7DBK5SiSI@ifi.uio.no> <45B95213.5060202@shaw.ca>
In-Reply-To: <45B95213.5060202@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2007 14:47:00.0465 (UTC) FILETIME=[D5E23E10:01C74158]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Fei Liu wrote:
>> Hello group, I have some concern about scheduling issue with 2.4.16 
>> and 2.4.22 i386 kernel where I see 1200+ interrupts and context 
>> switches per second through vmstat when machine is under load. Is 
>> this behavior normal? Is there any know scheduling issue with the 
>> above mentioned kernel versions?
>
> That number doesn't seem too unusual..
>
Thanks, Is there a summary page of scheduler changes made between 2.4 
and 2.6. I searched google etc but not really finding anything useful.

Fei
