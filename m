Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972Ab0A1R6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0A1R6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 12:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503Ab0A1R6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 12:58:42 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:17864 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab0A1R6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 12:58:41 -0500
Message-ID: <4B61D02A.9030500@caviumnetworks.com>
Date: Thu, 28 Jan 2010 09:58:02 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
       jschopp@austin.ibm.com, davej@redhat.com
Subject: Re: [PATCH] checkpatch.pl: remove the 80 charactes punch card limit
References: <1264597747.3607.29.camel@wall-e> <87hbq6dy2k.fsf@basil.nowhere.org>
In-Reply-To: <87hbq6dy2k.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2010 17:58:04.0833 (UTC) FILETIME=[70BF7910:01CAA043]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Stefani Seibold <stefani@seibold.net> writes:
> 
>> The time of 80 characters punch card and terminals are over, so i would
>> be a good thing to set the line length limit to 120. Every display today
>> should be able handle this. 
>>   
>> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> 
> Full Ack!
> 
> -Andi


I agree, but if people still have problems with it, perhaps reevaluating 
Joe Perches' patch:

http://lkml.org/lkml/2009/12/18/3

could be an alternative.

David Daney
