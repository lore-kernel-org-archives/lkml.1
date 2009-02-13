Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbZBMQXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbZBMQXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZBMQW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:22:56 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:59508 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZBMQWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:22:55 -0500
Date: Fri, 13 Feb 2009 10:22:52 -0600
From: David Engel <david@istwok.net>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.27.17
Message-ID: <20090213162252.GA17121@opus.istwok.net>
References: <20090213013157.GA14377@kroah.com> <49952552.6040000@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49952552.6040000@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 10:46:26AM +0300, Michael Tokarev wrote:
> Greg KH wrote:
> > Here's the announcement of the 2.6.27.17 kernel.
> > 
> > It reverts one patch in the 2.6.27.16 kernel release, which caused an
> > instant oops if you happened to have a laptop with a docking station.
> > Many thanks to David Engel for pointing out the problem.
> 
> > Greg Kroah-Hartman (2):
> >       Revert "ACPI: dock: Don't eval _STA on every show_docked sysfs read"
> >       Linux 2.6.27.17
> 
> I wonder if the same should be done with 2.6.28.5...

I haven't updated most of my systems to 2.6.28 yet.  I just gave
2.6.28.5 a try on my laptop, though.  It does not have the show_docked
oops I had with 2.6.27.16.

David
-- 
David Engel
david@istwok.net
