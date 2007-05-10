Return-Path: <linux-kernel-owner+w=401wt.eu-S1762721AbXEJVtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbXEJVtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759963AbXEJVtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:49:36 -0400
Received: from gw.goop.org ([64.81.55.164]:41184 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759586AbXEJVtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:49:36 -0400
Message-ID: <4643936B.8060708@goop.org>
Date: Thu, 10 May 2007 14:49:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com,
       michal.k.k.piotrowski@gmail.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <20070510004918.GS85884050@sgi.com> <46426D31.8070000@goop.org> <20070510012609.GU85884050@sgi.com> <46433049.4020003@goop.org> <20070510211348.GC86004887@sgi.com> <46438F67.9060503@goop.org>
In-Reply-To: <46438F67.9060503@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>   I haven't checked
> this comprehensively

I just did.  They're all pure truncations.

    J
