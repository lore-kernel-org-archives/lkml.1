Return-Path: <linux-kernel-owner+w=401wt.eu-S965466AbXAXAj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965466AbXAXAj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965468AbXAXAj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:39:27 -0500
Received: from mail.gmx.net ([213.165.64.20]:57481 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965466AbXAXAj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:39:26 -0500
X-Authenticated: #5039886
Date: Wed, 24 Jan 2007 01:39:23 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Larry Walton <lwalton@real.com>, s0348365@sms.ed.ac.uk, pomac@vapor.com,
       chunkeey@web.de, Jeff Garzik <jeff@garzik.org>
Subject: Re: SATA exceptions with 2.6.20-rc5
Message-ID: <20070124003923.GA3093@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Robert Hancock <hancockr@shaw.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Larry Walton <lwalton@real.com>, s0348365@sms.ed.ac.uk,
	pomac@vapor.com, chunkeey@web.de, Jeff Garzik <jeff@garzik.org>
References: <fa.1kBz5luWz8nR0lLqm1VD4hZZYdw@ifi.uio.no> <fa.QZxgjxcwtENaZNY24NMTlKBSgIM@ifi.uio.no> <fa.fkPTbUGmKc/1pt0eD6TE4d02n+Q@ifi.uio.no> <fa.6iQt5OtHZ3x5w8eYbLxwULhLTJ0@ifi.uio.no> <fa.1aqo3IxNGJClHcBVZNTagX6bL9o@ifi.uio.no> <fa.rI60BGlFbSyfLyumqmgiOfDqCI4@ifi.uio.no> <45B697D3.4070707@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45B697D3.4070707@shaw.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.01.23 17:18:43 -0600, Robert Hancock wrote:
> Larry Walton wrote:
> >The last patch (sata_nv-force-int-dev-in-interrupt.patch) 
> >seems to have fix the problem.  Much appreciated, 
> >thank you. I'd consider it a must have in 2.6.20.
> 
> Can any of the rest of you that have been seeing this problem also 
> confirm that this fixes it?

Seems to work for me, uptime is about an hour now and no exception yet.
Had the stress test running for only about 10 minutes, but I usually got
an exception within an hour even during plain irssi usage, so I'm quite
confident that the patch fixes it.

Thanks,
Björn
