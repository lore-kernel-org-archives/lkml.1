Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbXE3RYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbXE3RYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXE3RYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:24:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105AbXE3RYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:24:04 -0400
Date: Wed, 30 May 2007 13:23:31 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH -mm] 1/2: MMCONFIG: validate against ACPI motherboard resources
Message-ID: <20070530172331.GB2794@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Robert Hancock <hancockr@shaw.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>
References: <465CF794.1070406@shaw.ca> <alpine.LFD.0.98.0705292125511.26602@woody.linux-foundation.org> <465D8BA1.1080800@shaw.ca> <alpine.LFD.0.98.0705300804140.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705300804140.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 08:05:28AM -0700, Linus Torvalds wrote:
 > 
 > 
 > On Wed, 30 May 2007, Robert Hancock wrote:
 > > 
 > > I'll try and fix up the formatting and repost this patch.
 > 
 > Thanks.
 > 
 > >							 I suspect some
 > > of the issues are from the added code clashing with the way the existing
 > > code was formatted.
 > 
 > Well, I have to admit that I might not have reacted so much if it hadn't 
 > been for the Thunderbird thing, which made it look _really_ strange at 
 > first, so then I had to go outside my mail client to look closer. And once 
 > I looked closer, I just went "aiieee, it wasn't all the email client" ;)

I got fed up of telling people to reconfigure their MUAs a long time
ago and ended up with this in my .procmailrc

:0fw
| /usr/bin/perl -pe 's/^(Content-Type: .*)format=flowed/\1format=flawed/'

It doesn't solve all the worlds problems, but it least makes that crap
readable in _my_ MUA.  Sadly, if it's a patch that I have to apply
then chances are I'll have to get them to resend it with something
else anyway, as it's inevitably buggered in some other way because
thunderbird really is that dire.

I'm convinced there's some contest to see who can make the worst
graphical mail client for Linux. I'm not sure what the prize is,
or who's winning, but the entries so far are horrific.

	Dave

-- 
http://www.codemonkey.org.uk
