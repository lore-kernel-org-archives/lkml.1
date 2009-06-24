Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbZFXVlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbZFXVlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZFXVlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:41:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZFXVlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:41:35 -0400
Date: Wed, 24 Jun 2009 14:37:18 -0700
From: Greg KH <gregkh@suse.de>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       linux-usb@vger.kernel.org, oliver@neukum.name
Subject: Re: [PATCH 2/3] Fix oops when closing ACM tty device right after
	open has failed.
Message-ID: <20090624213718.GA13639@suse.de>
References: <1245843077-4442-1-git-send-email-cascardo@holoscopio.com> <1245843077-4442-2-git-send-email-cascardo@holoscopio.com> <20090624204106.GE28516@suse.de> <20090624213522.GH5299@vespa.holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624213522.GH5299@vespa.holoscopio.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 06:35:23PM -0300, Thadeu Lima de Souza Cascardo wrote:
> On Wed, Jun 24, 2009 at 01:41:06PM -0700, Greg KH wrote:
> > On Wed, Jun 24, 2009 at 08:31:16AM -0300, Thadeu Lima de Souza Cascardo wrote:
> > > This commit 10077d4a6674f535abdbe25cdecb1202af7948f1 has stopped
> > 
> > Please don't reference git commit ids that are not in Linus's tree, as
> > it doesn't make any sense to anyone.
> > 
> 
> It is in Linus's tree. git log torvalds/master..10077d4 gives me
> nothing.

Oh, ok, your phrase was a bit confusing.

It should say:
	The commit XXXXX has stopped...

thanks,

greg k-h
