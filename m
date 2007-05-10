Return-Path: <linux-kernel-owner+w=401wt.eu-S1762778AbXEJVqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762778AbXEJVqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXEJVqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:46:33 -0400
Received: from gw.goop.org ([64.81.55.164]:41160 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbXEJVqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:46:31 -0400
Message-ID: <464392B4.3070009@goop.org>
Date: Thu, 10 May 2007 14:46:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com>
In-Reply-To: <46439185.5060207@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> What CPU architecture is this happening on? Not i686 with PAE by
> any chance?

Yes.  Why?

    J
