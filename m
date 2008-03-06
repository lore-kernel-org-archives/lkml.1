Return-Path: <linux-kernel-owner+w=401wt.eu-S934753AbYCFCec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934753AbYCFCec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934399AbYCFC25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:28:57 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:40819 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934390AbYCFC24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:28:56 -0500
Date: Wed, 5 Mar 2008 18:28:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jike Song <albcamus@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc4 rcupreempt.h WARNINGs while suspend/resume
Message-ID: <20080306022854.GK8728@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <a8e1da0803042324ndd3873ay61cee6112d9dda9a@mail.gmail.com> <df9815e70803042335j4ea66028y96d6be21f0970aa1@mail.gmail.com> <20080305165531.GB8728@linux.vnet.ibm.com> <df9815e70803051811o4c4a42e0td56cfd32b80c66b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df9815e70803051811o4c4a42e0td56cfd32b80c66b2@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 10:11:26AM +0800, Jike Song wrote:
> On Thu, Mar 6, 2008 at 12:55 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >  Could you please try applying Karsten Wiese's patch to see if it
> >  fixes the WARNINGs?  See http://lkml.org/lkml/2008/2/26/386 for
> >  the patch.
> >
> >                                                 Thanx, Paul
> 
> Yes, the WARNING disappears with Karsten's patch applied.
> Thanks.

Good to hear!!!  I believe that Karsten's patch is on its way in,
so hopefully that will clear things up.

						Thanx, Paul
