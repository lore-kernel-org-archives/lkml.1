Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbZJBFND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbZJBFND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 01:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbZJBFND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 01:13:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:51866 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbZJBFNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 01:13:01 -0400
Date: Thu, 1 Oct 2009 22:10:56 -0700
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [000/136] 2.6.31.2-stable review
Message-ID: <20091002051056.GA7181@suse.de>
References: <20091002012911.GA18542@kroah.com> <m1tyyixuc1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tyyixuc1.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 10:01:34PM -0700, Eric W. Biederman wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > Note from the -stable maintainer on this release:
> >
> >   This release is big.  Yeah, really big.  There are a number of
> >   areas that needed some rework in order to get things back to
> >   working order.  Like the tty layer.  Hopefully everyone can now
> >   use their usb to serial devices again without oopsing the
> >   kernel
> 
> The ftdi_sio driver still crashes and burns.

What were you doing when it crashed?  I tested the pl2303 device and it
worked fine for me here, I don't have a ftdi_sio one :(

thanks,

greg k-h
