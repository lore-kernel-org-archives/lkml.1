Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZHSXlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZHSXlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZHSXjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:39:46 -0400
Received: from kroah.org ([198.145.64.141]:60556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbZHSXjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:39:42 -0400
Date: Wed, 19 Aug 2009 16:36:51 -0700
From: Greg KH <greg@kroah.com>
To: Christian Roche <christian.roche.fr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops: sysfs: duplicate filename 'usbdev3.3_ep81' can not be
 created
Message-ID: <20090819233651.GB2875@kroah.com>
References: <589ee1d0908160656u40672d47i7a7abe9923681f09@mail.gmail.com>
 <20090817044450.GB20884@kroah.com>
 <589ee1d0908171837u70e14c41hdd6fd4ab0aa50c7@mail.gmail.com>
 <20090818015504.GA29939@kroah.com>
 <589ee1d0908181353o5a648242p702ec607b78c2e56@mail.gmail.com>
 <20090818211946.GA23309@kroah.com>
 <589ee1d0908191516v173d448bt87f72a324284d92d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <589ee1d0908191516v173d448bt87f72a324284d92d@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 11:16:28PM +0100, Christian Roche wrote:
> >> In particular I get the following error :
> >> > setserial /dev/ttyACM0
> >> /dev/ttyACM0: Input/output error
> >
> > That's a different error.
> 
> Yes indeed, in fact the error was simply due to the fact that I needed
> to modprobe usbserial before rather than after the switch. So it was
> totally unrelated.
> 
> > That's some other problem.  It would be great if you could try out the
> > 2.6.31-rc kernel as work has gone on in this area.
> 
> Well I'm willing to do that, however I think I'll have to wait until
> they compile one 2.6.31 kernel for Fedora 11, because it looks like
> currently I would have to totally mess up my installation to do that.
> Since the whole issue is only a warning I guess this is not too much
> of a problem, unless you deem it important in which case I'm ok to try
> it.

Nah, I wouldn't worry about it.

thanks,

greg k-h
