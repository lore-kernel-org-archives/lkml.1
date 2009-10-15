Return-Path: <linux-kernel-owner+w=401wt.eu-S935259AbZJOVi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935259AbZJOVi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933560AbZJOViz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:38:55 -0400
Received: from bar.sig21.net ([80.81.252.164]:46215 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758175AbZJOViy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:38:54 -0400
Date: Thu, 15 Oct 2009 23:38:13 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bob Copeland <me@bobcopeland.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [Bug #13948] ath5k broken after suspend-to-ram
Message-ID: <20091015213813.GA16582@sig21.net>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
 <L6tb-VyKHZK.A.oyE.O1l0KB@chimera>
 <b6c5339f0910111719m58cd5442h3e081adfb388e8f1@mail.gmail.com>
 <200910122324.30052.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910122324.30052.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -4.1 (----)
X-Spam-21-Report: No, score=-4.1 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.287,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 11:24:29PM +0200, Rafael J. Wysocki wrote:
> On Monday 12 October 2009, Bob Copeland wrote:
> > On Sun, Oct 11, 2009 at 7:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13948
> > > Subject         : ath5k broken after suspend-to-ram
> > > Submitter       : Johannes Stezenbach <js@sig21.net>
> > > Date            : 2009-08-07 21:51 (66 days old)
> > > References      : http://marc.info/?l=linux-kernel&m=124968192727854&w=4
> > > Handled-By      : Nick Kossifidis <mickflemm@gmail.com>
> > > Patch           : http://patchwork.kernel.org/patch/38550/
> > 
> > This patch was included in 2.6.31.2, so I believe this can go.
> 
> Thanks, closing.

Sorry for not responding earlier.  I now installed
2.6.31.4 on my old Thinkpad T42p and can confirm that
the issue is resolved.

Thanks
Johannes
