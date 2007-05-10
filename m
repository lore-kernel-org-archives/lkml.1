Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbXEJXHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbXEJXHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760888AbXEJXHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:07:33 -0400
Received: from gw.goop.org ([64.81.55.164]:41057 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760314AbXEJXHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:07:32 -0400
Message-ID: <4643A5B2.3060906@goop.org>
Date: Thu, 10 May 2007 16:07:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org> <20070510225834.GF86004887@sgi.com>
In-Reply-To: <20070510225834.GF86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> Just to confirm this isn't a result of a recent change, can you reproduce
> this on a 2.6.20 or 2.6.21 kernel? (sorry if you've already done this - I've juggling
> some many things at once it's easy to forget little things).

It is the result of a recent change.  I had seen no problem until around
2.6.21-git8-11.  I will try again with a plain 2.6.21 kernel, just to
confirm.

    J

