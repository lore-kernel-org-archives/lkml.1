Return-Path: <linux-kernel-owner+w=401wt.eu-S1750782AbXDFVyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782AbXDFVyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXDFVyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:54:44 -0400
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:41868 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750782AbXDFVyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:54:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WfSA45SEUubKgyE28/yk44Md1gHjWCs4GRRQnXAYq7LAzDxF51LZ6Z8Jd7n2H1G1VEGYDTjialXmj6UXvRkDMn7rSqH8d0gMNy3ASgvnAdZfm8H+TywKyoRRO36C14OHn2xl/Q6MzYVlv+q1UXvH3mhYcn0+PE89++Ld3s01F4E=  ;
X-YMail-OSG: mmhD_ZYVM1ksnzccfj6ilF_4JjKKCpkDOFqE2iqfXjhgKkKqblYEq4ULX3XI7WM8oQpC3hx9Wg--
From: David Brownell <david-b@pacbell.net>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ... blinky leds!!)
Date: Fri, 6 Apr 2007 14:54:40 -0700
User-Agent: KMail/1.7.1
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
References: <11757099691323-git-send-email-tony@atomide.com> <200704061405.50169.david-b@pacbell.net> <4616BDA6.7090209@goop.org>
In-Reply-To: <4616BDA6.7090209@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061454.40709.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 2:37 pm, Jeremy Fitzhardinge wrote:
> David Brownell wrote:
> > Please change your coding style to conform to Documentation/CodingStyle.
> >
> > 	***	Only indent with tabs!!		***
> >
> > Every one of those examples violates that simple rule.
> >   
> 
> Spaces are used to indent all over the kernel; using a few spaces to pad
> out some indentation into the proper place is accepted practice,

Not universally.  And I must say it feels wrong to be the target of even
a single complaint about actually **FOLLOWING THAT RULE** ... 


> regardless of what CodingStyle says.

