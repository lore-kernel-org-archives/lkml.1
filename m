Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbYHFORe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbYHFORe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 10:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbYHFORA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 10:17:00 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:30310 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757447AbYHFOQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 10:16:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KBlfEuLlVuzQ/wKy3l6FRwLk5JNIzcCT/XnOMkPodV++WbhbBPnYbZN9UVi6Sro1RKqM2mza229XdJn4QIs0OOT60EqeMLV+LFl5HhC7hdfMPpMdInwNymzGHh/HT/DLQ3QGcmuiZdWJZLvlnEoFBzL4yu8gcGLS8JFlRJtuPTU=  ;
X-YMail-OSG: XpjzQqEVM1mHOExTUycApotgL3AcDiZ8jXrkTkpUZ3nXlhjS2pfHJHuaHFZhdXxQ3j2ztaJ1H63vLxAnpOK02RE_w8wQtGlvQ1pSi1dNbszSSzMmMmqwZxuoItNqvKhecCY-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Date: Thu, 7 Aug 2008 00:16:49 +1000
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <87r6926dsr.fsf@basil.nowhere.org> <4899A313.7020708@tmr.com>
In-Reply-To: <4899A313.7020708@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808070016.49585.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008 23:11, Bill Davidsen wrote:
> Andi Kleen wrote:
> > Nick Piggin <nickpiggin@yahoo.com.au> writes:
> >> Seriously? Because it doesn't seem to have had enough peer review,
> >> it hasn't had widespread testing in somewhere like linux-next or
> >> -mm, and we already have kgdb so you have to also explain why you
> >> can't improve kgdb in the areas it trails mdb.
> >>
> >> But the ideal outcome would be if you could contribute patches to
> >> kgdb to the point where it is as good as mdb. It is already in the
>
> That idea sounds familiar, the "suspend2" response, when something new
> and significantly different is offered, instead of putting it in and
> letting people choose in configuration, take the position that what is
> there is good enough, and if the author of the new solution will just
> drop all their ideas and slap some band-aids on the existing code it
> will be "gooder enough" without actually offering people a choice of
> something different.

No. First try to integrate them together so you have the best of both
from one code base is what I was saying. I specifically said if they
are significantly different and can't be reconciled then it could be
merged.
