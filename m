Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbZCJSxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbZCJSxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZCJSxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:53:04 -0400
Received: from adelie.canonical.com ([91.189.90.139]:41136 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbZCJSxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:53:02 -0400
Date: Tue, 10 Mar 2009 18:52:59 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: make -f alias --file, add --help, more
	verbose help message
Message-ID: <20090310185259.GA27061@shadowen.org>
References: <20090112092839.GA2190@elf.ucw.cz> <496B0E5F.1020902@tremplin-utc.net> <20090116121940.GA30302@elf.ucw.cz> <20090116143404.ccf2d9ee.akpm@linux-foundation.org> <20090120103219.GK2576@elf.ucw.cz> <20090310172026.10948.10453.stgit@f10box.hanneseder.net> <20090310181023.GC28243@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310181023.GC28243@shadowen.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 06:10:23PM +0000, Andy Whitcroft wrote:
> On Tue, Mar 10, 2009 at 06:21:23PM +0100, Hannes Eder wrote:
> > Impact:
> >   - More verbose help/usage message.
> >   - Make the option -f an alias for --file.
> >   - On -h, --help, and --version display help message and exit(0).
> >   - With no FILE(s) given, exit(1) with "no input files".
> >   - On invalid options display help/usage and exit(1).
> > 
> > Based on a patch by Pavel Machek.
> 
> That looks reasonable.  Will integate it into my next set of updates.

Ok, now in my testing branch.  See:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
