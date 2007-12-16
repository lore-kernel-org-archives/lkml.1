Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbXLPJYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbXLPJYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 04:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbXLPJXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 04:23:45 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:60618 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098AbXLPJXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 04:23:42 -0500
Subject: Re: problem with ending requests asynchronously in my block device
	driver
From: Jon Masters <jonathan@jonmasters.org>
To: a_kumar <cable_plug2000@yahoo.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <14354996.post@talk.nabble.com>
References: <14354996.post@talk.nabble.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sun, 16 Dec 2007 04:23:06 -0500
Message-Id: <1197796986.28864.10.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-12-15 at 12:52 -0800, a_kumar wrote:

> I've a block device driver which does the following, 

Why not send the actual code?

> This code works fine with most of the kernel versions, but fails on some
> like , Linux 2.6.18-8.el5-xen 

You've provided no information. What we need:

*). A well formed report, complete with oops, panic, other output.
*). Description of how it "fails".

Note also that there is no upstream Linux "2.6.18-8.el5-xen" kernel.

There is a Red Hat Enterprise Linux kernel release with that revision
(this is the one that shipped in the GA RHEL5.0 kernel). You should
contact your vendor for support with their kernel if you are unable to
provide a well-formed bug report against an upstream kernel release.

Jon.


