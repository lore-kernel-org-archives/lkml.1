Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbXEXQ6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbXEXQ6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbXEXQ6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:58:08 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59926 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760AbXEXQ6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:58:06 -0400
Date: Thu, 24 May 2007 09:58:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <409105.81786.qm@web52606.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0705240957430.28086@schroedinger.engr.sgi.com>
References: <409105.81786.qm@web52606.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Srihari Vijayaraghavan wrote:

> slabinfo -v produces this error message:
> Cannot write to Acpi-Namespace/validate

You need to be root to do this. Sorry.


