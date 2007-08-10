Return-Path: <linux-kernel-owner+w=401wt.eu-S1765660AbXHJASf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765660AbXHJASf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 20:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbXHJAS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 20:18:28 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:55927 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbXHJAS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 20:18:26 -0400
Message-ID: <46BBAE05.3080103@gmail.com>
Date: Fri, 10 Aug 2007 02:15:01 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Andi Kleen <andi@firstfloor.org>, Hans-J?rgen Koch <hjk@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
References: <20070809113122.3aa508e4@oldman.hamilton.local> <200708091508.20626.hjk@linutronix.de> <p73hcn8g25m.fsf@bingen.suse.de> <20070809191036.GA23596@electric-eye.fr.zoreil.com> <20070809193031.GB32280@one.firstfloor.org> <20070809222735.GB23596@electric-eye.fr.zoreil.com>
In-Reply-To: <20070809222735.GB23596@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2007 12:27 AM, Francois Romieu wrote:

> Andi Kleen <andi@firstfloor.org> :
> [...]

>> I don't think that is used by Linuxdoc. Try a make pdfdocs and see for
>> yourself.
> 
> It reminds me of an old PII but it does not really make clear how html to
> pdf conversion would improve the situation.

With HTML the source format is itself the preferred object format for many 
purposes (something which I assume you wouldn't want to claim of DocBook 
source) meaning that for those uses there is no conversion.

Which given the number of times "make *docs" has bombed out on me through 
the years I find a definite improvement. Add in that it's much easier to 
produce HTML, that it covers most all formatting needs something like the 
kernel documentation directory needs, integrates unchanged, directly and 
nicely into the effort Rob Landley is doing with collecting documentation 
online and is a format you can read with a program most users have open and 
available 100% of the time rather than requiring a complete stack of 
semi-obscure external software -- and I just don't see why anyone would want 
to argue that DocBook and its associated crapola should _not_ be buried in 
that same dark, desolate place where other abortive attempts at improvement 
such as GNU info already reside.

Rene.

