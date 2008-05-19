Return-Path: <linux-kernel-owner+w=401wt.eu-S1763500AbYESVjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763500AbYESVjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbYESVjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:39:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46698 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbYESVjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:39:14 -0400
Date: Mon, 19 May 2008 14:36:05 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH 01/20] tty: Introduce a tty_port common structure
Message-ID: <20080519213605.GC31619@kroah.com>
References: <20080519144557.19326.74313.stgit@core> <20080519145013.19326.38344.stgit@core> <20080519174738.GA20961@uranus.ravnborg.org> <20080519175121.GA25150@kroah.com> <20080519204804.1b21c0e7@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519204804.1b21c0e7@core>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 08:48:04PM +0100, Alan Cox wrote:
> On Mon, 19 May 2008 10:51:21 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Mon, May 19, 2008 at 07:47:39PM +0200, Sam Ravnborg wrote:
> > > Hi Alan.
> > > 
> > > On Mon, May 19, 2008 at 03:50:13PM +0100, Alan Cox wrote:
> > I'll run them through checkpatch.pl and fix up any minor things like
> > this before sending them off, that's part of my normal patch-queue
> > process :)
> 
> Please do *NOT* do that. It messes up resolving them against pending and
> further patches that are not upstream. If you insist on doing that then I
> will submit the patches myself via a different tree which does not.
> 
> By all means report cases where checkpatch isn't clean on them and send
> me diffs to go back via my devel tree however.

Ok, will do, I understand.  I think that one mention of an exported
symbol will be flagged, I'll let you know about any further ones.

thanks,

greg k-h
