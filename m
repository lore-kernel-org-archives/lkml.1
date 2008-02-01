Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYBAHEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYBAHEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYBAHEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:04:45 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:63613 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYBAHEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:04:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CB3p7cVEilCZIvVsQGlX4DzsYODsGRPvbPIoMJZ85envoJiOq1rgqIFoo1KjxAakFLY1F+UeLf0Anq2e/FDUpFL/wlK0kj9KbRAXbA87ZxXgu6akfDM4Q5IBNUMU+5I/Wpe3OSL9AXTHPBC52bGuDoSFhPwx6g+RQd1741l+rAw=
Subject: Re: Feature Removals for 2.6.25
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
In-Reply-To: <47A2BD22.4020106@linux.intel.com>
References: <1201829922.23523.68.camel@brick>
	 <47A2A5D8.4080700@linux.intel.com> <1201843092.23523.80.camel@brick>
	 <47A2BD22.4020106@linux.intel.com>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 23:04:20 -0800
Message-Id: <1201849460.23523.92.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-31 at 22:33 -0800, Arjan van de Ven wrote:
> Harvey Harrison wrote:
> > Something like the following (grep found me two example symbols)
> 
> to be honest, nobody reads this file with such detail; the actual UNUSED marking
> is a lot more louder and people are more likely to notice those.... for all I care
> we nuke the entire entry from the removals file.

Well, if there is interest in having an up-to-date file, I'm willing to
do the bookkeeping to make this usable and try to keep it up to date.

Anybody think this is worthwhile?

Harvey

