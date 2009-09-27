Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZI0U73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZI0U73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 16:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZI0U72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 16:59:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:39611 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbZI0U70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 16:59:26 -0400
Date: Sun, 27 Sep 2009 13:59:00 -0700
From: Greg KH <gregkh@suse.de>
To: Sven Joachim <svenjoac@gmx.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.31.1
Message-ID: <20090927205900.GA32554@suse.de>
References: <20090924174002.GE17077@kroah.com>
 <87pr9egqpc.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pr9egqpc.fsf@turtle.gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 08:33:51AM +0200, Sven Joachim wrote:
> On 2009-09-24 19:40 +0200, Greg KH wrote:
> 
> > I'm announcing the release of the 2.6.31.1 kernel.  All users of the
> > 2.6.31 kernel series are very strongly encouraged to upgrade.
> 
> Stable kernel releases used to be announced on
> linux-kernel-announce@hera.kernel.org, but apparently they are not any
> more; the last version announced there was 2.6.30.5.
> 
> Is there an easy way to get informed about new stable kernel releases
> without having to subscribe to high-volume mailing lists or to poll a 
> website?

linux-kernel-announce should work, perhaps something recently broke when
the backend kernel-org stuff was changed.  Try pinging the kernel.org
admins about this.

thanks,

greg k-h
