Return-Path: <linux-kernel-owner+w=401wt.eu-S933919AbZINU2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919AbZINU2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933909AbZINU2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:28:37 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:35096 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933533AbZINU2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HCJ4PSspFet+dDG00cTtoMZxPtjil2eara7PA+NsH5czKK4/0oJK6kNPb0y0JJKD+g
         iubhXW8CT9AsUKtI0XehlZxD0UviPBc7x2gbtMu70wuh2hhGhCTpFD4c+JxS8Ud32NPx
         18vwYnDWjyZUKJZyDAA+ZCQsAaA7wjfUtAHyo=
Date: Mon, 14 Sep 2009 22:28:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] ftrace: document basic ftracer/ftracer graph needs
Message-ID: <20090914202833.GE6045@nowhere>
References: <20090614012457.GD5986@nowhere> <1244948719-22216-1-git-send-email-vapier@gentoo.org> <1252957702.20020.53.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252957702.20020.53.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 03:48:22PM -0400, Steven Rostedt wrote:
> > +HAVE_FTRACE_SYSCALLS
> > +---------------------
> > +
> > +<details to be filled>
> 
> This would be for Frederic.



Yep. Especially there may be some movement from arch code to core
wrt syscall tracing in the .33 development cycle so once it is done
I can document this part.

