Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbZIZBEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbZIZBEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 21:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZIZBEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 21:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbZIZBEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 21:04:24 -0400
Message-ID: <4ABD6930.6070500@redhat.com>
Date: Sat, 26 Sep 2009 09:06:56 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC Patch] kbuild: remove -Wdeclaration-after-statement
References: <20090923094034.23512.90809.sendpatchset@localhost.localdomain> <20090923105157.GA31281@merkur.ravnborg.org>
In-Reply-To: <20090923105157.GA31281@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Wed, Sep 23, 2009 at 05:38:01AM -0400, Amerigo Wang wrote:
>> I got lots of "ISO C90 forbids mixed declarations and code" warnings
>> during compile today's kernel.
>>
>> I think we can remove the gcc option '-Wdeclaration-after-statement'
>> now, since we already have C99 for 10 years. :)
> 
> This is a matter of style more than what C99 allows.
> Kernel style is to fobid this(*) so we keep the warning.
> 
> (*) Based on reading several threads where this has
> been mentioned - I have no specific references to CodingStyle.

Ah, Ok, no problem.

Thanks, everyone!
