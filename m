Return-Path: <linux-kernel-owner+w=401wt.eu-S1752241AbYBQVc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbYBQVc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbYBQVcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:32:41 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:18480 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbYBQVck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:32:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ixU85ooETZy3Q6mRxxFm3zgWXDs1peFR9VIeaheX7Gb6ZkQgmsqhY7hrIQ2GANq1mjGJbiOrPbXvdYGmsqmG73nFMKhbKLGkZTirWxjJiTKZE2rCbgRzuj91LqkE5GU9RoeWlzKFTlMB2AWwtfbNg5gyt/HSuweQXL/C/G8XqsQ=
Message-ID: <64bb37e0802171332x6a0d18cdr1c3fcf72918883ac@mail.gmail.com>
Date: Sun, 17 Feb 2008 22:32:38 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc2
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200802172125.56177.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
	 <200802172125.56177.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2008 9:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> There's the Bugzilla entry for it at
> http://bugzilla.kernel.org/show_bug.cgi?id=9973

Thank you.

> Please update it with the current information.

Crash for 2.6.25-rc2-mm1 added. That one had a complete stacktrace,
but the trace looks like others I already reported, so no real new
information... :-(

Torsten
