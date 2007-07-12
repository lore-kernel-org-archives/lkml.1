Return-Path: <linux-kernel-owner+w=401wt.eu-S934825AbXGLQO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934825AbXGLQO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbXGLQOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:14:47 -0400
Received: from canuck.infradead.org ([209.217.80.40]:52075 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934115AbXGLQOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:14:46 -0400
Date: Thu, 12 Jul 2007 09:14:02 -0700
From: Greg KH <greg@kroah.com>
To: Mark Shelby <mshelby1@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel autoconfig option?
Message-ID: <20070712161402.GA18550@kroah.com>
References: <78ecab220707120718q7cfcff43u66f80711c7ec1005@mail.gmail.com> <Pine.LNX.4.64.0707121635120.25352@fbirervta.pbzchgretzou.qr> <78ecab220707120802p11ab3e1fye497f4107fe18c1d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78ecab220707120802p11ab3e1fye497f4107fe18c1d@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 11:02:15AM -0400, Mark Shelby wrote:
>  That's an excellent idea. I am still thinking along the lines of
>  "idiot proof simplicity." It would be nice to have a configure script
>  that scanned your system board, sound card/chip various input ports,
>  etc, and went ahead and preselected those to build when you type
>  "make.
> 
>  If you could combine this with the make "allmodconfig" command in a
>  user friendly interface, I think you'd really be on to something!
>  --as long as it's still configurable after the preselected choices are
>  made.

Check the archives, this comes up every 6 months or so.

Also, you can just use the simple scripts as described in the book,
"Linux Kernel in a Nutshell", free online, to do most of what you are
looking for here (automatic detection of what driver is needed for what
device.)

good luck,

greg k-h
