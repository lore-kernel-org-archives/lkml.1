Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbXHaX30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbXHaX30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 19:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXHaX3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 19:29:18 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:50701 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbXHaX3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 19:29:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=S7lvmvTYJAADdNgeukIbLGOIJoSgIAJk83Qzn8K5MDWCG7BCQnZuwPAzFIOSMszn;
  h=Received:Message-ID:Reply-To:From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <000501c7ec26$c2b06140$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: "\"Robert P. J. Day\"" <rpjday@mindspring.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
Date: Fri, 31 Aug 2007 16:29:20 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79720d6d0e801c558afcc5535d810e39a6350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.164.91.49
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert P. J. Day" wrote:
> 
>   at the risk of driving everyone here totally bonkers, i'm going to
> take one last shot at explaining what i was thinking of when i first
> proposed this whole "maturity level" thing.  and, just so you know,
> the major reason i'm so cranked up about this is that i'm feeling just
> a little territorial -- i was the one who first started nagging people
> to consider this idea, so i'm a little edgy when i see folks finally
> giving it some serious thought but appearing to get ready to implement
> it entirely incorrectly in a way that's going to ruin it irreparably
> and make it utterly useless.
> 
>   this isn't just about defining a single feature called "maturity".
> it's about defining a general mechanism so that you can add entirely
> new (what i call) "attributes" to kernel features.  one attribute
> could be "maturity", which could take one of a number of possible
> values.  another could be "status", with the same restrictions.
> heck, you could define the attribute "colour", and decide that various
> kernel features could be labelled as (at most) one of "red", "green"
> and "chartreuse."  that's what i mean by an "attribute", and
> attributes would have two critical and non-negotiable properties:
<<< snip>>>>
> 
>   but i hope i've flogged this thoroughly to the point where people
> can see what i'm driving at.  once you see (as in simon's patch) how
> to add the first attribute, it's trivial to simply duplicate that code
> to add as many more as you want.
> 
> rday
> 
> --
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
> 
> http://crashcourse.ca
> ========================================================================
Robert Day,

        If I can interpret what you are asking about and changing it abit.

        Don't you think that Maturity can be defined ALSO, as the 
       number of known bugs and their priority / serverity against a 
       architecture dependent or independent item?

       Would this suffice and wouldn't it be easier to maintain?

       Mitchell Erblich
