Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbYCMMCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbYCMMCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYCMMBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:01:55 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:20689 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbYCMMBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=sbzEtFNg4G4lPwe3ZGf+T5MYXMcPdXKbadGPXrBFYcZoKFWV8Xrv/9Awk/2Gd5GRwBndse1xqBXuGgmAQNEveRTDNYDWo92/8ElEUN+lhEeprpLb3N/a+B3H+hXAT7nuhvEfdV/rPdb9I45Z4e4Zx8Uge0MAduH9EVrJUHxbJmM=
Date: Thu, 13 Mar 2008 09:02:38 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Jan Knutar <jk-lkml@sci.fi>, linux-kernel@vger.kernel.org,
       Hans-Peter Jansen <hpj@urpla.net>, Jiri Kosina <jkosina@suse.cz>,
       David Newall <davidn@davidnewall.com>, Theodore Tso <tytso@mit.edu>,
       "Fred ." <eldmannen@gmail.com>
Subject: Re: Keys get stuck
Message-ID: <20080313120238.GA3860@localhost.ift.unesp.br>
Mail-Followup-To: Mike Galbraith <efault@gmx.de>,
	Jan Knutar <jk-lkml@sci.fi>, linux-kernel@vger.kernel.org,
	Hans-Peter Jansen <hpj@urpla.net>, Jiri Kosina <jkosina@suse.cz>,
	David Newall <davidn@davidnewall.com>, Theodore Tso <tytso@mit.edu>,
	"Fred ." <eldmannen@gmail.com>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <200803122222.05663.hpj@urpla.net> <1205386933.4797.22.camel@marge.simson.net> <200803131148.22056.jk-lkml@sci.fi> <1205407693.6686.16.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205407693.6686.16.camel@marge.simson.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13.Mar'08 at 12:28:13 +0100, Mike Galbraith wrote:
>[...]
> Swap can definitely keep X off the cpu for extended periods,
>[...]

So I would like to ask if swap letting X (and everything else
in my experience) out of the cpu for extended periods is
considered normal behaviour, in the sense that nobody is
trying to "fix" it (due to it being considered impossible
to fix)...?

Sorry for being off-topic, but I run a minimal Window Maker
desktop in a P4 3.0 GHz with 512 MB of RAM (around 140 MB
being used as per 'free'), and trying to load a 380 MB text
file in xjed editor makes my whole desktop quite unfair...
it takes tens of seconds to switch desktop, type things in
the terminal etc. 

When xjed finishes loading the text file, everything comes
back to "fair" again.

Is there some law in the nature of computers which says
that when swapping everything else waits for swap to finish 
its business? I hope not :-)





