Return-Path: <linux-kernel-owner+w=401wt.eu-S1765382AbXHJXbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765382AbXHJXbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 19:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXHJXa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 19:30:57 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:34933 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbXHJXa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 19:30:56 -0400
Message-ID: <46BCF458.7010300@gmail.com>
Date: Sat, 11 Aug 2007 01:27:20 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>,
       =?ISO-8859-15?Q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
References: <20070809113122.3aa508e4@oldman.hamilton.local> <200708091508.20626.hjk@linutronix.de> <p73hcn8g25m.fsf@bingen.suse.de> <20070810074047.GC31307@uranus.ravnborg.org> <46BC6DA9.1050903@s5r6.in-berlin.de> <20070810201235.GA4133@uranus.ravnborg.org>
In-Reply-To: <20070810201235.GA4133@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2007 10:12 PM, Sam Ravnborg wrote:

>> What primary requirements does in-tree Linux kernel documentation have
>> to fulfill in general?
> 
> Skipping the obvious ones such as correct, up-to-date etc.
> o Readable as-is
> o Grepable
> o buildable as structured documents or almost like a single book
> o Easy to replicate structure
> o Maintainable in any decent text-editor (emacs, vim, whatever)

Easy to put online?

> Asciidoc is quite close to plaintext and it looks to me that the
> formatting possibilities are quite good.
> 
> I spend an hour experimenting a little with
> Documentation/kbuild/makefiles.txt.
> 
> Diff below shows quite a lot of changes but for the most
> this is removal of the indent tab.
> Most likely I could have tweaked asciidoc to accept this
> but wanted to use default config.
> 
> The resulting html page can be seen here:
> http://www.ravnborg.org/kbuild/makefiles.html

FWIW, this looks very good to me...

Rene.

