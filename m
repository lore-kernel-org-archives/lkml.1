Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbZCPAY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbZCPAY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 20:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZCPAYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 20:24:17 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:45854 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbZCPAYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 20:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iFYt3Cb3GYm7ZjP4HJLGMoM0jUQZEfC4BRzO8tHA/cFUktQ+oE0rLxEKKnNLsuUmH5
         uO/80oMpWTg2p2bgBzCj+6wkEwaBOplCuwioHe90UTGHOkFUC97E2XjViFHNa13YxXhR
         JSzK8+fkZEY79gbSA58UzmDgB3Yf3W+1wKvRQ=
Date: Mon, 16 Mar 2009 02:24:05 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12574] possible circular locking dependency detected
Message-ID: <20090316002404.GA12662@google.com>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.pCF.R6BvJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GCLaknAim2M.A.pCF.R6BvJB@chimera>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 08:05:29PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12574
> Subject		: possible circular locking dependency detected
> Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
> Date		: 2009-01-29 11:35 (45 days old)
> References	: http://lkml.org/lkml/2009/2/9/205
> 

It's still there in rc8.

