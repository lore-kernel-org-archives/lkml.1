Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbZAJGMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbZAJGMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 01:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZAJGLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 01:11:49 -0500
Received: from 1wt.eu ([62.212.114.60]:1377 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZAJGLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 01:11:48 -0500
Date: Sat, 10 Jan 2009 07:11:42 +0100
From: Willy Tarreau <w@1wt.eu>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Kernel Blocking Firewall
Message-ID: <20090110061142.GE4819@1wt.eu>
References: <40416.166.70.238.44.1231467823.squirrel@webmail.wolfmountaingroup.com> <20090109064658.GG5038@1wt.eu> <20090110004031.GA21537@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110004031.GA21537@khazad-dum.debian.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 10:40:31PM -0200, Henrique de Moraes Holschuh wrote:
> On Fri, 09 Jan 2009, Willy Tarreau wrote:
> > why didn't you use ipset for that ? It's designed exactly for this usage
> > and is a lot easier to use than plain iptables for dynamic filtering.
> 
> Any ideas when it will hit mainline?

no idea.

> ipsets and PF_RING are the only ways
> to get two important jobs done:  non-trivial firewalling on high-speed
> links, and packet capture in said links...

yes, that's a bit right.

>  and neither is in mainline AFAIK.

Well, you should ask Joszef for the former and Luca for the later :-)

Regards,
Willy

