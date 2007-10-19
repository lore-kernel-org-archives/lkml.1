Return-Path: <linux-kernel-owner+w=401wt.eu-S936137AbXJSTDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936137AbXJSTDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbXJSTDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:03:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48730 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764839AbXJSTDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:03:03 -0400
Message-ID: <4718FF60.4010500@garzik.org>
Date: Fri, 19 Oct 2007 15:02:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/9] Remove 'irq' argument from all irq handlers
References: <20071019075443.GA6407@havoc.gtf.org>	<alpine.LFD.0.9999.0710191649120.22770@localhost.localdomain> <m1bqavgdbf.fsf@ebiederm.dsl.xmission.com> <4718FE2B.1030909@garzik.org>
In-Reply-To: <4718FE2B.1030909@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Once that effort is done, everything should be in the 'trivial' pile and 
> not have the logic that you are worried about (and thus there would be 
> no need to add an additional branch to the error handling path).

er, s/error/irq/

the perils of a multi-threaded brain...

