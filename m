Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305Ab0A0UbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab0A0UbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228Ab0A0UbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:31:22 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:47821 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab0A0UbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:31:22 -0500
Message-ID: <4B60A288.2010909@austin.ibm.com>
Date: Wed, 27 Jan 2010 14:31:04 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
       davej@redhat.com
Subject: Re: [PATCH] checkpatch.pl: remove the 80 charactes punch card limit
References: <1264597747.3607.29.camel@wall-e> <4B6080C5.7020306@austin.ibm.com> <4B608D78.4040606@caviumnetworks.com>
In-Reply-To: <4B608D78.4040606@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>>
>> While the origins of 80 character lines dates back to punchcards 
>> there is a reason it has survived the test of time.
>
> Has it though?  If that were the undisputed truth, we wouldn't be 
> having this discussion.

If you know of a usability study that quantifies the effect of line 
length on readibility of C code I'm willing to listen, and I'm sure 
others are too.
