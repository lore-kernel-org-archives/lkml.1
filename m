Return-Path: <linux-kernel-owner+w=401wt.eu-S938019AbXGMXN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938019AbXGMXN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762391AbXGMXMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:12:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57671 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759736AbXGMXMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:12:47 -0400
Message-ID: <469806EC.1050104@zytor.com>
Date: Fri, 13 Jul 2007 16:12:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>
CC: "J.H." <warthog19@eaglescrag.net>
Subject: kernel.org needs gitweb help
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A lot of people have asked me if there is anything they can do to help
out kernel.org.  At this point, the number one thing anyone could do to
help, and which would be reasonably self-contained a project, would be
to help maintain our fork of gitweb:

http://git.kernel.org/?p=git/warthog9/gitweb.git;a=summary

We really need the caching version of gitweb, but it does have a number
of problems, including the non-working tarball generator.

	-hpa
