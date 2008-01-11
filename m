Return-Path: <linux-kernel-owner+w=401wt.eu-S1760806AbYAKJim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806AbYAKJim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbYAKJie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:38:34 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:43278 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbYAKJid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:38:33 -0500
Subject: Re: [PATCH] checkpatch.pl: allow piping
From: Daniel Walker <dwalker@mvista.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Bernd Petrovitsch <bernd@firmix.at>, apw@shadowen.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
In-Reply-To: <47873833.30001@gmail.com>
References: <20080111041120.085610726@mvista.com>
	 <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com>
	 <47873505.7040008@gmail.com>  <1200043399.3905.9.camel@gimli.at.home>
	 <1200043827.29897.70.camel@imap.mvista.com>  <47873833.30001@gmail.com>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 01:36:46 -0800
Message-Id: <1200044206.29897.73.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 10:34 +0100, Jiri Slaby wrote:
> On 01/11/2008 10:30 AM, Daniel Walker wrote:
> > On Fri, 2008-01-11 at 10:23 +0100, Bernd Petrovitsch wrote:
> >> On Fre, 2008-01-11 at 10:21 +0100, Jiri Slaby wrote:
> >>> git show 9914cad54c79d0b89b1f066c0894f00e1344131c
> >> | ./scripts/checkpatch.pl -
> >>
> >> JftSoC:
> >> git show 9914cad54c79d0b89b1f066c0894f00e1344131c
> >> | ./scripts/checkpatch.pl /dev/stdin
> >> (and there a a few others) should also do the trick.
> > 
> > Not a particularly attractive command line .. Might still be a good idea
> > to add this since these two forms alluded me, and are likely to allude
> > people new to unix all together (who is more likely to be using this
> > particular tool)..
> 
> If somebody is hacking kernel, I think he should know the - trick used in many 
> programs, but do not consider this as a nack.

I'm hacking the kernel, and I didn't know the - trick .. So you have
your testing case all in one with the patch submitter ..

Daniel

