Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbXICDLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbXICDLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 23:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbXICDLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 23:11:45 -0400
Received: from keil-draco.com ([216.193.185.50]:50567 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbXICDLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 23:11:44 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: davids@webmaster.com
Subject: Re: Fwd: That whole "Linux stealing our code" thing
Date: Sun, 2 Sep 2007 23:11:33 -0400
User-Agent: KMail/1.9.6
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <MDEHLPKNGKAHNMBLJOLKOECFGJAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOECFGJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709022311.33534.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(by the way, text in caps surrounded by *'s is meant to indicate vocal stress, 
not volume)

On Sunday 02 September 2007 22:01:18 David Schwartz wrote:
<snip>
> > So I appear to have a
> > right to convey the work under the GPL to a third party, who from me
> > receives no right to use it except under the GPL.
>
> Here's where your train goes off the rails. They do not receive any right
> to use it from you. They receive a license to use it under the GPL from the
> original author. Please read GPL section 6.
>
> "  6. Each time you redistribute the Program (or any work based on the
> Program), the recipient automatically receives a license from the
> original licensor to copy, distribute or modify the Program subject to
> these terms and conditions.  You may not impose any further
> restrictions on the recipients' exercise of the rights granted herein.
> You are not responsible for enforcing compliance by third parties to
> this License."
>
> The GPL does not give you *any* right to extend anyone a license to code
> you did not author. (Nor can it as such an extension would have to be done
> in writing in most countries.) When you distribute a GPL'd work, the right
> to use every creative element in that work is licensed to the recipients
> directly from their respective authors. Under no circumstances does the GPL
> ever give you the ability to license someone else's work to a third party.

However, this is not what is happening here. Jiri has made changes that he has 
licensed solely under the GPLv2. This means that he now becomes the 
licensor - not Mr. Floeter or Mr. Leffler. *BUT* *ONLY* of the version of the 
code containing his changes.

Mr. Floeter *CAN* request that his code be removed from said fork - his code 
is solely licensed (AFAICT and IIRC) under the BSD/ISC license and was only 
covered by the dual-license because it was integrated into a work that 
carried said dual-license. (I'm not sure how well such a revocation would 
work in reality, but it is Mr. Floeters right.)...

(Sam Leffler could do the same - but I'm not sure how well that would carry.)

> >  * Alternatively, this software may be distributed under the terms of the
> >  * GNU General Public License ("GPL") version 2 as published by the Free
> >  * Software Foundation.
> >
> > The choice appears to be delegated to the recipient very clearly and
> > very specifically by the licencing on the file. It does not say that I
> > must convey the work under both licences. It quite specifically says I
> > may convey the work under whichever of the two I prefer (and probably
> > both if I wish). Clearly if that had not been the intent it would not
> > have included the clause giving the choice.
>
> Either license can grant you the right to distribute it, but how you get
> the rights to distribute has *NO* effect on the recipient. They receive a
> lawful copy and any rights the original author grants them under a license
> from that original author. You have no power to grant or modify rights to
> the original work.

Correct. Doesn't apply in the case of the code in question (unless the changes 
that were made are so tiny as to not be copyrightable).

In this case the code is question is a modified version, which means that the 
right to distribute said modified version now originates with the person 
holding the copyright on the modifications. (Though their right to distribute 
the code, in such a situation, is lessened quite a bit by the text of the 
license they received the code under)

> This is a common misunderstanding.

No misunderstanding, really.

Alan seems to have given a bad example that doesn't apply to the situation 
that is being discussed.

> Note that you may remove the text of either license from a dual-licensed
> file and redistribute under the other license because neither license
> requires you to retain the other license and both licenses give you the
> right otherwise to modify as you wish. But the removal of a license from a
> file has no effect on the grant of license. Your recipients still get a
> dual license to those protectable elements in the file that were placed
> under a dual license. You cannot stop the automatic grant.

Agreed. When re-distributing an un-modified copy of a work. When distributing 
a modified work, the "work" has the license that the person who made the 
modifications places on it. But individual files and pieces of code will 
still retain their original license - this is how it works.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
