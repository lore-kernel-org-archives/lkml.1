Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbZE2GGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbZE2GGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 02:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZE2GF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 02:05:59 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:4287 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbZE2GF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 02:05:59 -0400
Date: Fri, 29 May 2009 08:05:47 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Greg KH <greg@kroah.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LM Sensors <lm-sensors@lm-sensors.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH-tip] x86: hwmon/k8temp.c Add  support for AMD 10H and
 11H
Message-ID: <20090529080547.38ecfed8@hyperion.delvare>
In-Reply-To: <1243575735.3159.7.camel@localhost.localdomain>
References: <4A165F67.3020005@assembler.cz>
	<1242981748.10642.3.camel@localhost.localdomain>
	<1242984648.16532.3.camel@localhost.localdomain>
	<4A182B61.5010503@assembler.cz>
	<1243339833.12303.2.camel@localhost.localdomain>
	<4A1C08C6.7060103@assembler.cz>
	<1243352672.31783.10.camel@localhost.localdomain>
	<1243511849.3669.5.camel@localhost.localdomain>
	<20090528142837.530ba070@hyperion.delvare>
	<1243520014.3143.11.camel@localhost.localdomain>
	<20090528144901.GA7153@kroah.com>
	<1243575735.3159.7.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009 11:12:15 +0530, Jaswinder Singh Rajput wrote:
> Hi Greg,
> 
> On Thu, 2009-05-28 at 07:49 -0700, Greg KH wrote:
> > On Thu, May 28, 2009 at 07:43:34PM +0530, Jaswinder Singh Rajput wrote:
> > > I proposed for stable because I was using AMD 11H from last 6 months and
> > > I was missing temperature monitor badly because my earlier Laptop was
> > > broken by overheating. So I thought if it goes to stable then users will
> > > start getting benefit of it, but if you want that users should wait for
> > > another 2 years. Then it is OK ;-)
> > 
> > 2 years?  The next kernel release will be out in 3 months, we have a
> > very predictable release schedule.
> 
> I am sorry for being unclear. I meant for linux distros. Even one of the
> most active Fedora 10 is using vmlinuz-2.6.27.24-170.2.68.fc10.x86_64 is
> almost 7 months behind the linus git. And another linux distro are still
> using 2.6.22 or so which are almost 2 years behind linus git.

Distributions are free to backport any patch they like to their kernel
tree, at any time.

-- 
Jean Delvare
