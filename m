Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbYHVAaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbYHVAaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 20:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbYHVA3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 20:29:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34092 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYHVA3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 20:29:54 -0400
Date: Thu, 21 Aug 2008 14:29:52 -1000
From: Joshua Hoblitt <josh@hoblitt.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080822002952.GG23377@hoblitt.com>
References: <bug-11388-27@http.bugzilla.kernel.org/> <20080820180405.7f164450.akpm@linux-foundation.org> <86802c440808201820w6c684a10y2f1d0f70a344a14a@mail.gmail.com> <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com> <20080821205558.GC23377@hoblitt.com> <86802c440808211451u4483f88ft845cd20c3f23c53a@mail.gmail.com> <20080821233317.GE23377@hoblitt.com> <20080822001047.GF23377@hoblitt.com> <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lol.  No - I thought you implied it was in the tip tree.  Sigh.  I'll
try again.

-J

--
On Thu, Aug 21, 2008 at 05:28:51PM -0700, Yinghai Lu wrote:
> On Thu, Aug 21, 2008 at 5:10 PM, Joshua Hoblitt <josh@hoblitt.com> wrote:
> > The dmesg from the tip kernel is attached and it's at least larger than
> > the last builds dmesg.
> 
> did you apply my debug patch?
> you should get msr print out...
> 
> YH
