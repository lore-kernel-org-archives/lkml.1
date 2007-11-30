Return-Path: <linux-kernel-owner+w=401wt.eu-S935195AbXK3QIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935195AbXK3QIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 11:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933999AbXK3QIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 11:08:37 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:62486 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933744AbXK3QIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 11:08:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MHWqlIFXlA3gUDu/646WoXQqVH873Ol8D6gzKoe7tBjkBjaGCC2pYTPuuz2P4RZblhMxS1eQjHoLHyXQilxmd9XOdVpNdh/SGLFR+3xqYiLXBTgFx8vT7ymLJFMwJktfHrqFn8S7EubZcqFbzhde8v6R4n9hB59PTy5ZOQZ2MgU=
Message-ID: <cfd18e0f0711300808v186b66f3v9a3298d52970f2f3@mail.gmail.com>
Date: Fri, 30 Nov 2007 17:08:20 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, ak@suse.de, suresh.b.siddha@intel.com,
       "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <cfd18e0f0711300804t42508ba0k57ee524f8ebeb216@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com>
	 <20071129155940.7df70ac2.akpm@linux-foundation.org>
	 <cfd18e0f0711300804t42508ba0k57ee524f8ebeb216@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 30, 2007 5:04 PM, Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
> [...]
>
> > Please cc Michael Kerrisk <mtk-manpages@gmx.net> on future versions of
> > these patches.
>
> Yes, please.  Buit note that my official address nowadays is
>
> mtk-manpages@gmail.com

Ooops!  I meant mtk.manpages@gmail.com!

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
