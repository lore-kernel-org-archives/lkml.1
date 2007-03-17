Return-Path: <linux-kernel-owner+w=401wt.eu-S964981AbXCQH3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981AbXCQH3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 03:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964896AbXCQH3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 03:29:44 -0400
Received: from sccrmhc14.comcast.net ([204.127.200.84]:33646 "EHLO
	sccrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbXCQH3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 03:29:42 -0400
Subject: Re: RSDL v0.31
From: Nicholas Miell <nmiell@comcast.net>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070317072535.GA2986@holomorphy.com>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703170040.48316.kernel@kolivas.org>
	 <1174059299.7886.25.camel@Homer.simpson.net>
	 <200703170813.32594.kernel@kolivas.org>
	 <1174084207.7009.9.camel@Homer.simpson.net>
	 <1174105443.3144.4.camel@entropy>
	 <1174110965.7911.44.camel@Homer.simpson.net>
	 <1174112768.3144.8.camel@entropy>
	 <1174115517.7911.66.camel@Homer.simpson.net>
	 <20070317072535.GA2986@holomorphy.com>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 00:29:38 -0700
Message-Id: <1174116578.3144.10.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-17 at 00:25 -0700, William Lee Irwin III wrote:
> On Sat, Mar 17, 2007 at 08:11:57AM +0100, Mike Galbraith wrote:
> > On a side note, I wonder how long it's going to take to fix all the
> > X/client combinations out there.
> 
> AIUI X's clients largely access it via libraries X ships, so the X
> update will sweep the vast majority of them in one shot. You'll have
> to either run the clients from remote hosts with downrev libraries or
> have downrev libraries around (e.g. in chroots) for clients to link to
> for the clients not to cooperate.
> 

The changes will probably be entirely server-side anyway, so stray
ancient libraries won't be a problem.

-- 
Nicholas Miell <nmiell@comcast.net>

