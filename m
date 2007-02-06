Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXBFKOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXBFKOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 05:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXBFKOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 05:14:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57226 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbXBFKOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 05:14:07 -0500
Date: Tue, 6 Feb 2007 02:13:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       jkenisto@us.ibm.com, anil.s.keshavamurthy@intel.com,
       prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [RFC] [PATCH] To list all active probes in the system
Message-Id: <20070206021300.698ecb2c.akpm@linux-foundation.org>
In-Reply-To: <45C85097.1000106@in.ibm.com>
References: <45C85097.1000106@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Feb 2007 15:25:35 +0530 Srinivasa Ds <srinivasa@in.ibm.com> wrote:

>         I have developed a patch, that lists all active probes in the
> system.

userspace added the probes, so userspace should know where they all are?
