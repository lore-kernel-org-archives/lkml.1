Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbZKRRcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbZKRRcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:32:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbZKRRcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:32:03 -0500
Received: from mail.crlf.net ([216.235.14.184]:64744 "EHLO mail.crlf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757688AbZKRRcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:32:02 -0500
Date: Wed, 18 Nov 2009 12:32:07 -0500
From: David Maxwell <dmaxwell@coverity.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Coverity checking periodicity?
Message-ID: <20091118173207.GB6796@mail>
References: <20091118153935.GA6796@mail> <4B042C94.9070403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B042C94.9070403@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 06:19:16PM +0100, Jiri Slaby wrote:
> On 11/18/2009 04:39 PM, David Maxwell wrote:
> > You mentioned the stats on the Scan site not being updated. That's true.
> > I haven't had time to do maintenance on the relevant scripts in quite a while,
> > so the site doesn't reflect the ongoing builds and defect count changes. :-(
> 
> David, thank you for the reply. I'm just curious, are the results
> publicly available or are they visible only to few chosen people?

Hi Jiri,

Each open source project can set their own rules about how small a group
of people can have access to the results. Some projects are very
sensitive about potential security issues and keep it to a few core
folks.

Other projects are less strict. In the Linux case, I forward any
requests off to a handful of Linux people who give me a thumbs-up/down
on the request.

Generally, if I get a request from a maintainer, it has always been
approved.

--
David Maxwell
Coverity Open Source Strategist
http://scan.coverity.com/
