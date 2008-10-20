Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYJTBFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYJTBFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 21:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYJTBFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 21:05:47 -0400
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:46829 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbYJTBFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 21:05:46 -0400
X-Greylist: delayed 2320 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Oct 2008 21:05:46 EDT
Date: Sun, 19 Oct 2008 18:27:02 -0600
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.27: "irq 18: nobody cared" on Toshiba
	Satellite A100
Message-ID: <20081020002702.GA2641@ellpspace.math.ualberta.ca>
References: <48FB3ED5.60904@superonline.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FB3ED5.60904@superonline.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 10:06:13AM -0400, M. Vefa Bicakci wrote:
> 
> As you might guess from the subject line, since I started to use 2.6.27-rcX
> series, I began to get "irq 18: nobody cared" messages in dmesg.

I have seen something of that sort on x86_64 machine, and only with
2.6.27-rcX kernels, but there this was "irq 16: nobody cared".  Various
details are at https://bugzilla.redhat.com/show_bug.cgi?id=466575

This happens infrequently and unpredictably so I have no idea
how to reproduce.  I do not have anything connected which is served
by this interrupt so for me effects were limited to kernel
complaints.

Recently I did not bump into that.

   Michal
