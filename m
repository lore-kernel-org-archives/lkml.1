Return-Path: <linux-kernel-owner+w=401wt.eu-S1761213AbZANJJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761213AbZANJJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZANJJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:09:35 -0500
Received: from kandzendo.ru ([195.178.208.66]:41850 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbZANJJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:09:33 -0500
Date: Wed, 14 Jan 2009 12:09:32 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [8/7] dst: kconfig update.
Message-ID: <20090114090932.GB22347@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net> <1231887933-17843-2-git-send-email-zbr@ioremap.net> <1231887933-17843-3-git-send-email-zbr@ioremap.net> <1231887933-17843-4-git-send-email-zbr@ioremap.net> <1231887933-17843-5-git-send-email-zbr@ioremap.net> <1231887933-17843-6-git-send-email-zbr@ioremap.net> <1231887933-17843-7-git-send-email-zbr@ioremap.net> <1231887933-17843-8-git-send-email-zbr@ioremap.net> <20090113230943.GA30952@ioremap.net> <20090113182251.1cda2d64.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113182251.1cda2d64.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 06:22:51PM -0800, Randy Dunlap (randy.dunlap@oracle.com) wrote:
> >  	---help---
> >  	DST is a network block device storage, which can be used to organize
> >  	exported storages on the remote nodes into the local block device.
> >  
> > -	DST is a network block device storage, which can be used to organize
> > -	exported storages on the remote nodes into the local block device.
> > -
> >  	DST works on top of any network media and protocol, it is just a matter
> >  	of configuration utility to understand the correct addresses. The most
> >  	common example is TCP over IP allows to pass through firewalls and
> 
> ah, i see.

I created patches against wrong tree, so it does not contain your
excellent language fixes and above paragraph was just a small part of
the needed patch :)
It exists in the exported git tree, but not this patch series.

-- 
	Evgeniy Polyakov
