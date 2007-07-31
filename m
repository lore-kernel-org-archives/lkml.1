Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbXGaMqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbXGaMqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbXGaMqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:46:12 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4553 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbXGaMqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:46:11 -0400
Message-ID: <46AF2F10.40001@shadowen.org>
Date: Tue, 31 Jul 2007 13:46:08 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: lkml <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
Subject: Re: [PATCH] Check patch reports multiple var with a function assignment
References: <46AEA245.9090300@windriver.com>
In-Reply-To: <46AEA245.9090300@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> Running checkpatch.pl products an warning when it should not.  I believe
> it can be fixed by adding to the regular expression, but feel free to
> fix it another way as I may not know all the cases this is trying to catch.

Thanks for the patch.  We had already caught this one and the test
itself now is likely to be shelved, a new release with this update in is
iminent.

-apw
