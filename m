Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZA2CLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZA2CLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 21:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbZA2CLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 21:11:43 -0500
Received: from n4.bullet.mail.ac4.yahoo.com ([76.13.13.28]:42322 "HELO
	n4.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758378AbZA2CLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 21:11:42 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 983734.86665.bm@omp106.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=E7APyc0r51nCi4l2Hj0kXdel9iSsO6bbtoOFN1fKdNxP9U5EAqO4LtASBTwPWmeo9hGPzR2RL/6hU8U4w6yQBh6OinUJB6FvKbUoVpyzr34C4qCidbhnk9ZXfSyyqn8J469xAsUzWv6hZRw1bGXQjKpKjyUADJbiBJPYXl/OMUI=;
X-YMail-OSG: gDkmHv4VM1l3RIJUtWCaPKKQmpf_gb90lf.7XwjzJ6Vi7HW61sqms8eKjE64ZafLhBBt4e5oxqQorkNZEDd_p2D4UQz7NT7QclFByy2CXGk4.ObIUu2sBERxWLzc8dOPNWgjSjnHCQy91LIvZGGfOem9iA7iux6XmiGY_ghM.m3Ctmx9CwbAchexFmUF
X-Mailer: YahooMailWebService/0.7.260.1
Date: Wed, 28 Jan 2009 18:11:40 -0800 (PST)
From: Xiaoning Ding <dingxn@ymail.com>
Reply-To: dingxn@ymail.com
Subject: Re: a question about p4_clockmod module on Xeon quad core processors
To: Wes Felter <wesley@felter.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4980C8A9.6090904@felter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <765076.76058.qm@web59913.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I installed msr-tools, but could not find detailed information on how to change cpu speed with the tools. Can you point me to detailed documentations? Or, can you share your code?

Thanks!

Xiaoning

--- On Wed, 1/28/09, Wes Felter <wesley@felter.org> wrote:

> From: Wes Felter <wesley@felter.org>
> Subject: Re: a question about p4_clockmod module on Xeon quad core processors
> To: dingxn@ymail.com
> Cc: linux-kernel@vger.kernel.org
> Date: Wednesday, January 28, 2009, 9:05 PM
> Xiaoning Ding wrote:
> > Hi list,
> > 
> > I have tried the p4-clockmod module in Linux kernel
> 2.6.29 on Xeon 5355 quad-core CPUs with no luck. It seems
> current p4-clockmod driver still cannot support Intel Quad
> core processors, right? 
> > I know I can also use acpi-cpufreq. It can only scale
> down the frequence from 2.67GHz to 2GHz. But I need some
> lower frequencies for some experiments.
> 
> Clock modulation is quite simple; in the past I've done
> it from userspace with /dev/cpu/*/msr or written my own
> module to do it. I don't know if I've ever tried it
> on quad-cores, but it worked on dual-core Woodcrest. (Note:
> I was not trying to save energy.)
> 
> Wes Felter - wesley@felter.org


      

