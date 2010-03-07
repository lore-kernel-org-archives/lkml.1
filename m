Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951Ab0CGWwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 17:52:18 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:33170 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab0CGWwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 17:52:17 -0500
Message-ID: <4B942E1E.1070204@linux.vnet.ibm.com>
Date: Sun, 07 Mar 2010 14:52:14 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Fabian Korak <fkorak@stud.fh-offenburg.de>, linux-kernel@vger.kernel.org
Subject: Re: Perf doesn't accept i915:i915_gem_request_wait_begin as an event
References: <4B93BF8C020000DD00024397@tula.rz.fh-offenburg.de> <4B93F813.9080707@linux.vnet.ibm.com> <20100307110441.50dca8cd@infradead.org>
In-Reply-To: <20100307110441.50dca8cd@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2010 11:04 AM, Arjan van de Ven wrote:
> On Sun, 07 Mar 2010 11:01:39 -0800
> Corey Ashford<cjashfor@linux.vnet.ibm.com>  wrote:
>>
>> I find the example given on that web page quite confusing because
>> perf currently doesn't have support for arch-dependent events like
>> that, except via "raw code" events which use the syntax -e
>> r<hex_code>. I wonder if they locally modified perf to handle those
>> events, and then forgot that they had made that modification before
>> posting up those instructions.
>
> these are just standard trace points...

Ah, I see.  Thanks for the correction.

- Corey
