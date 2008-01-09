Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYAISd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYAISd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 13:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbYAISdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 13:33:19 -0500
Received: from dvhart.com ([64.146.134.43]:45924 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYAISdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 13:33:18 -0500
Message-ID: <4785136C.7010300@mbligh.org>
Date: Wed, 09 Jan 2008 10:33:16 -0800
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, bugme-admin@linux-foundation.org,
       Peter Osterlund <petero2@telia.com>
Subject: Re: change SCSI owner in bugzilla
References: <20080106161635.GL2082@does.not.exist> <20080108160607.GA32273@elte.hu> <200801081849.06846.rjw@sisk.pl> <200801081851.55387.rjw@sisk.pl> <20080108221136.GA21482@elte.hu>
In-Reply-To: <20080108221136.GA21482@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
>>>>   Edit / Prefs / Email Preferences / Users to watch
>>>>
>>>> add power-management_other@kernel-bugs.osdl.org to that list and you'll 
>>>> be notified about new bugs and changes to existing bugs.
>>> Still, I'd like the list to be notified, not only me (eg. I might be 
>>> offline or or unable to respond at the moment, or someone else may 
>>> know how to fix the problem).
>> Ah, you mean I should create a bugzilla user for the list and add 
>> power-management_other@kernel-bugs.osdl.org to this user's watchlist.  
>> That will make sense. :-)
> 
> yep, and this way the special users have consistent layout as well. I 
> suspect the SCSI thing should be done this way as well. Martin, do you 
> agree with that, or is there some other issue?

I can try to do that, yes. Would be more consistent. Only concern is
Bugzilla's tendency to email passwords to the user, etc.


