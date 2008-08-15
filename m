Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbYHOWgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbYHOWgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbYHOWgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:36:08 -0400
Received: from mail.crca.org.au ([67.207.131.56]:50345 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbYHOWgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:36:08 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: PM_TRACE is no longer experimental
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Trivial patch monkey <trivial@kernel.org>
In-Reply-To: <48A5B8C8.6040504@imap.cc>
References: <20080814151833.GA23300@elf.ucw.cz>  <48A5B8C8.6040504@imap.cc>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Sat, 16 Aug 2008 08:34:29 +1000
Message-Id: <1218839669.9654.45.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2008-08-15 at 19:11 +0200, Tilman Schmidt wrote:
> On 14.08.2008 17:18 Pavel Machek wrote:
> > PM_TRACE is stable for quite long. I don't think it needs to depend on
> > experimental.
> 
> It might be stable, but its effect of trashing the RTC makes it unsuitable
> for non-experimental use. Therefore I'd prefer the dependency be kept.

I think you're confusing 'experimental' and 'debugging'. You certainly
wouldn't want to use it routinely, but that doesn't mean it's still an
experimental feature.

Regards,

Nigel

