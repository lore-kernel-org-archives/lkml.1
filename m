Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445Ab0AKPPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab0AKPPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 10:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193Ab0AKPPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 10:15:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45179 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752951Ab0AKPPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 10:15:22 -0500
Date: Mon, 11 Jan 2010 10:15:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Fruhwirth Clemens <clemens@endorphin.org>
Subject: Re: [linux-pm] 2.6.33-rc3-git3: Reported regressions 2.6.31 -> 2.6.32
In-Reply-To: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
Message-ID: <Pine.LNX.4.44L0.1001111008080.2873-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010, Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14841
> Subject	: unable to enumerate USB device on port X after suspend/resume
> Submitter	: Fruhwirth Clemens <clemens@endorphin.org>
> Date		: 2009-12-19 11:45 (23 days old)

This bug has been resolved as WILL NOT FIX.  It ended up having nothing
to do with suspend or resume, it was caused by strange behavior in the
device hardware.

Alan Stern

