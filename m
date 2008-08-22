Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYHVD0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYHVD0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 23:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYHVD0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 23:26:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60000 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYHVD0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 23:26:12 -0400
Date: Thu, 21 Aug 2008 17:26:09 -1000
From: Joshua Hoblitt <josh@hoblitt.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080822032609.GG31897@hoblitt.com>
References: <86802c440808211451u4483f88ft845cd20c3f23c53a@mail.gmail.com> <20080821233317.GE23377@hoblitt.com> <20080822001047.GF23377@hoblitt.com> <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com> <20080822002952.GG23377@hoblitt.com> <20080822010014.GH23377@hoblitt.com> <20080822011055.GI23377@hoblitt.com> <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com> <20080822021512.GJ23377@hoblitt.com> <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 07:26:35PM -0700, Yinghai Lu wrote:
> you may talk to your BIOS vendor or system vendor to request one new
> updated BIOS.

Thank you for diagnosing the problem so quickly!  I think those systems
(we have 16 in that set) are Tyan S539Xs, where X is a 6 or 7.  I'll
have to double check the exact model.

    http://www.tyan.com/product_board_detail.aspx?pid=562

I'll complain to Tyan about it during business hours tomorrow.  Any idea
as to why this issue didn't arise with earlier kernels?  I've had Tyan
technical support try to tell me to down rev. kernels in the past
instead of escalating the issue.  The more information I can give them
the better.

-J

--
