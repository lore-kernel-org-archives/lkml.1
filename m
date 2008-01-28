Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbYA1VAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbYA1VAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYA1VAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:00:39 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:47908 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYA1VAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:00:38 -0500
Message-ID: <479E4201.8040500@oracle.com>
Date: Mon, 28 Jan 2008 12:58:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: michael-lists@free-electrons.com, rob@landley.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Documentation: mention email-clients.txt in SubmittingPatches
References: <200801181120.03168.michael-lists@free-electrons.com>	<20080118083415.07c37f2a.randy.dunlap@oracle.com>	<20080128095245.f8306466.pj@sgi.com>	<20080128081759.4efa8544.randy.dunlap@oracle.com> <20080128133254.f70d50c2.pj@sgi.com>
In-Reply-To: <20080128133254.f70d50c2.pj@sgi.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Randy wrote:
>> Does Sylpheed IMAP do filtering for you?
>>
>> It does not according to the Sylpheed FAQ, but the FAQ is
>> extremely out of date.
> 
> You are correct that the Sylpheed FAQ, such as at:
> 
>     http://sylpheeddoc.sourceforge.net/en/faq/faq-1.html
> 
> states:
> 
>     1.8 Q08 Does Sylpheed have mail filtering?
>     A. Yes. You can find it in Configuration -> filtering tab.
>     Please note that filtering is not yet implemented for IMAP accounts. 
> 
> And you are correct -- that FAQ is out of date.  It seems to be
> dated 2002.
> 
> To answer your question, yes filtering now works fine on IMAP folders
> using Sylpheed.  I make heavy use of it.  I'm using Sylpheed version
> 2.2.4 at the moment.
> 
> ===
> 
> Be that as it may, whether Sylpheed IMAP folder filters worked or not,
> I'd suggest that the Documentation/email-clients.txt file not engage
> in evaluation of the general purpose feature sets of various email
> clients, but rather confine itself to what matters to the kernel
> mailing list, such as how to get patches formatted correctly.

Agreed.  I'll modify it.

-- 
~Randy
