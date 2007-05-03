Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbXECGMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbXECGMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbXECGMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:12:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31754 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbXECGMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:12:38 -0400
Date: Wed, 2 May 2007 23:12:33 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Bill Irwin <bill.irwin@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       wli@holomorphy.com
Subject: Re: [PATCH] i386: fix suspend/resume with dynamically allocated irq stacks
Message-ID: <20070503061233.GG26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070503054809.GF26598@holomorphy.com> <46397AA1.8090606@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46397AA1.8090606@goop.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin wrote:
>> Updated patch follows. Please add your Signed-off-by: if it meets your
>> approval;

On Wed, May 02, 2007 at 11:01:05PM -0700, Jeremy Fitzhardinge wrote:
> What does it apply to?  I'm getting conflicts if I replace my patch with
> this.  Or does it replace one of your patches?

I had the same question about yours and just brute-force merged. Not a
big deal for me to rediff against whatever everyone's working off of.


-- wli
