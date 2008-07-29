Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbYG2IrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbYG2IrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYG2Iqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:46:55 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:22949 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbYG2Iqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:46:55 -0400
Date: Tue, 29 Jul 2008 10:45:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Michael Holzheu <holzheu@de.ibm.com>
Subject: Re: [patch 02/15] kmsg: Kernel message catalog script.
Message-ID: <20080729084536.GA29659@uranus.ravnborg.org>
References: <20080728175355.734299984@de.ibm.com> <20080728175511.260174666@de.ibm.com> <20080728192828.GA11431@uranus.ravnborg.org> <1217320950.10259.15.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217320950.10259.15.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 10:42:30AM +0200, Martin Schwidefsky wrote:
> On Mon, 2008-07-28 at 21:28 +0200, Sam Ravnborg wrote:
> > > 
> > > The kmsg man page creation is invoked with "make K=2" and reads the source
> > > files for all built objects, looks up the message description and writes
> > > a man page to $(objtree)/man.
> > Can we use M=2 instead of K=?
> > I have sort of reserved 'K' for Kconfig usage.
> 
> Ok, K= is taken but I can't use M= either because that is used for KBUILD_EXTMOD.
> If tested with D= for "documentation", would that be okay ?

D sounds fine with me.

Dunno what drugs I was on when I suggested M :-(

	Sam
