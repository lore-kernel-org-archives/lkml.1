Return-Path: <linux-kernel-owner+w=401wt.eu-S965380AbXFGT3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965380AbXFGT3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764394AbXFGT3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:29:07 -0400
Received: from holomorphy.com ([66.93.40.71]:59958 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932728AbXFGT3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:29:06 -0400
Date: Thu, 7 Jun 2007 12:29:11 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: why does the macro "ZERO_PAGE" take an argument?
Message-ID: <20070607192911.GV6909@holomorphy.com>
References: <Pine.LNX.4.64.0706070715290.14293@localhost.localdomain> <4667EC18.4080904@yahoo.com.au> <Pine.LNX.4.64.0706070731250.14994@localhost.localdomain> <a781481a0706070439p6dda152l37e475ae0fa698ef@mail.gmail.com> <Pine.LNX.4.64.0706070750540.16051@localhost.localdomain> <4668412D.3030506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4668412D.3030506@zytor.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>> although it's not clear where in the source tree are the invocations
>> that would actually make a difference to a MIPS system, which is why
>> i've CC'ed ralf on this.  i'm sure he can clear this up. :-)

On Thu, Jun 07, 2007 at 10:32:29AM -0700, H. Peter Anvin wrote:
> x86 could also benefit from coloured zeropages.  In fact, I thought it
> already had them (K8 wants as many as 8.)

How would one demonstrate the beneficial effect of such?


-- wli
