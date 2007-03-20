Return-Path: <linux-kernel-owner+w=401wt.eu-S933464AbXCTJlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbXCTJlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933490AbXCTJlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:41:20 -0400
Received: from duempel.org ([81.209.165.42]:56411 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933464AbXCTJlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:41:19 -0400
Date: Tue, 20 Mar 2007 10:41:12 +0100
From: Max Kellermann <max@duempel.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.21-rc3-git9] SATA NCQ failure with Samsum HD401LJ
Message-ID: <20070320094112.GA4259@roonstrasse.net>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	linux-kernel@vger.kernel.org
References: <fa.wBi/iM3CKSfrll7UnPHTbU0scEQ@ifi.uio.no> <200703182131.00476.christiand59@web.de> <45FDF9EE.20303@gmail.com> <200703190808.00746.christiand59@web.de> <45FE7D74.6090503@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FE7D74.6090503@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007/03/19 13:09, Jeff Garzik <jeff@garzik.org> wrote:
> I may have missed the answer to this before, but: does the problem
> go away if you disable preempt?

On my system (same problem, original bug report), preemption is
disabled.

Max

