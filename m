Return-Path: <linux-kernel-owner+w=401wt.eu-S1751939AbYENVMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbYENVMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYENVL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:11:58 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60538 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753569AbYENVL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:11:57 -0400
Date: Wed, 14 May 2008 17:11:46 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Romano Giannetti <romano.giannetti@gmail.com>
Subject: Re: [Bug #10620] X does not resume (intel chipset)
Message-ID: <20080514211146.GG7054@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Romano Giannetti <romano.giannetti@gmail.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.cw.ww1JIB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88YBFoyd1CN.A.cw.ww1JIB@chimera>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 10:04:13PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10620
> Subject		: X does not resume (intel chipset)
> Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
> Date		: 2008-05-08 06:53 (4 days old)
> References	: http://lkml.org/lkml/2008/5/8/378

My symptoms were not identical to the ones which Romano reported
(which in turn were not identical to the ones which Hugh reported),
but Hugh's patch did fix things for me; so Romano might want to give
this a try:

http://lkml.org/lkml/2008/5/13/188

							- Ted
