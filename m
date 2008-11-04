Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYKDTdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYKDTdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYKDTdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:33:01 -0500
Received: from [74.13.241.36] ([74.13.241.36]:37663 "EHLO slyph.dragoninc.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYKDTdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:33:00 -0500
From: "Doug Nazar" <nazard@dragoninc.ca>
To: "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Jeff Garzik'" <jeff@garzik.org>
Cc: "'J. Bruce Fields'" <bfields@citi.umich.edu>,
       "'Al Viro'" <viro@zeniv.linux.org.uk>, <linux-kernel@vger.kernel.org>
References: <000301c93eaa$fae98460$f0bc8d20$@ca>	 <491097DA.9040204@garzik.org> <1225825411.11230.6.camel@macbook.infradead.org>
In-Reply-To: <1225825411.11230.6.camel@macbook.infradead.org>
Subject: RE: 2.6.28-rc3 truncates nfsd results
Date: Tue, 4 Nov 2008 14:32:54 -0500
Message-ID: <001901c93eb4$22026ef0$66074cd0$@ca>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ack+sBXwmtzX1tGWQPGd8WEpnm6ZrAAA+7wA
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's the commit I'm reverting <g>

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of David Woodhouse
> Sent: November 4, 2008 14:04
> To: Jeff Garzik
> Cc: Doug Nazar; 'J. Bruce Fields'; 'Al Viro'; linux-
> kernel@vger.kernel.org
> Subject: Re: 2.6.28-rc3 truncates nfsd results
> 
> On Tue, 2008-11-04 at 13:43 -0500, Jeff Garzik wrote:
> > I'll try reverting this and see if the behavior improves, thanks for
> the
> > pointer...
> 
> See attached...
> 
> --
> David Woodhouse                            Open Source Technology
> Centre
> David.Woodhouse@intel.com                              Intel
> Corporation

