Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189AbXCTIRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbXCTIRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 04:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbXCTIRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 04:17:19 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:10888 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbXCTIRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 04:17:17 -0400
Message-ID: <45FF9885.4090006@linux-kernel.at>
Date: Tue, 20 Mar 2007 09:17:09 +0100
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: axp question 'bout uname voodoo
References: <45FE80FD.9090109@linux-kernel.at> <m1ejnlxh4j.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ejnlxh4j.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.399, required 5, ALL_TRUSTED -1.80, BAYES_00 -2.60)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric!

On 03/19/2007 06:44 PM, Eric W. Biederman wrote:
> Oliver Falk <oliver@linux-kernel.at> writes:
[ ... ]
> The kernel uname function at least does not have fields that
> report processor or hardware platform.

But on i386 it reports:
[oliver@pils ~]$ uname -mpi
i686 i686 i386

And I remember that it used to report alphaev67 or alphaev56...

-of
