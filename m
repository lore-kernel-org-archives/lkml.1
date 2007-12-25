Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbXLYNwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbXLYNwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 08:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbXLYNwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 08:52:20 -0500
Received: from slackadelic.com ([65.196.224.53]:51885 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbXLYNwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 08:52:19 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: ACPI:  _PTS ordering needs fixing for pre ACPI 3.0 systems (was: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM)
Date: Tue, 25 Dec 2007 13:52:11 +0000
User-Agent: KMail/1.9.7
Cc: Robert Hancock <hancockr@shaw.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-acpi@vger.kernel.org
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no> <200712251436.52246.rjw@sisk.pl> <200712251507.24144.rjw@sisk.pl>
In-Reply-To: <200712251507.24144.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712251352.13902.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 December 2007 14:07:22 Rafael J. Wysocki wrote:
> OK, sorry, the approach is generally reasonable, IMO, but it needs to be a
> bit more fine grained.

I know, hence this was marked as a hack and not signed off; it's just a 
demonstration of the general idea with code instead of words.

> I'll try to prepare some patches along these lines soon.

Much appreciated - I'm much happier with someone who's more familiar with this 
code than I working on it.

-Carlos

(Now going back to unwrapping Christmas presents...)
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
