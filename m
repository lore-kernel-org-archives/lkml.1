Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbXL2ABl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbXL2ABl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 19:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbXL2ABb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 19:01:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:41014 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751575AbXL2ABb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 19:01:31 -0500
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1+ikslnF2yiAjH9DiiMhDSQkRAvKKvlCx7dxhF31B
	vgMf1lq/1/8gCX
From: Jan-Simon =?iso-8859-15?q?M=F6ller?= <dl9pf@gmx.de>
To: devzero@web.de
Subject: Re: kbuild: modules_install regression ? - depmod
Date: Sat, 29 Dec 2007 01:01:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <73443449@web.de>
In-Reply-To: <73443449@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712290101.23751.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 28 Dezember 2007 16:08:19 schrieb devzero@web.de:
> i have the same issue, but with 2.6.24-rc6 on a box with 512MB RAM
>
> System is openSUSE 10.3
>
> on "make modules_install" , depmod reproduceably dies with out of memory
> error when it is ~800MB VSZ and ~350MB RSS this happens on different
> hardware.
>
> any clue what`s going wrong?
> how much memory should i expect being needed with "make modules_install" ,
> e.g. with allmodconfig ?
>
>
No news/progress on this issue afaik !

