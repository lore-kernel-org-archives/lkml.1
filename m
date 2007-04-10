Return-Path: <linux-kernel-owner+w=401wt.eu-S1031433AbXDJSo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031433AbXDJSo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031389AbXDJSo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:44:56 -0400
Received: from smtp.osdl.org ([65.172.181.24]:40544 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031433AbXDJSoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:44:55 -0400
Date: Tue, 10 Apr 2007 11:44:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 4/6] Rename the parainstructions symbols to be
 consistent with the others
Message-Id: <20070410114437.d1eb492e.akpm@linux-foundation.org>
In-Reply-To: <200704102007.49163.ak@suse.de>
References: <20070404010655.400913479@goop.org>
	<20070404011453.598418421@goop.org>
	<200704102007.49163.ak@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 20:07:48 +0200 Andi Kleen <ak@suse.de> wrote:

> On Wednesday 04 April 2007 03:06:59 Jeremy Fitzhardinge wrote:
> > The other symbols used to delineate the alt-instructions sections have
> > the form __foo/__foo_end.  Rename parainstructions to match.
> 
> This patch breaks x86-64
> 

Fixed version is in 2.6.21-rc6-mm1.

Please let me know when you've uploaded your new tree...
