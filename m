Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYIJLow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYIJLow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYIJLoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:44:44 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:38977 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbYIJLoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:44:44 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Building Kernel with -O0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Wed, 10 Sep 2008 13:52:45 +0200
References: <b8rB2-6BM-1@gated-at.bofh.it> <badXc-7gl-21@gated-at.bofh.it> <baf2M-bE-7@gated-at.bofh.it> <bagBJ-20J-7@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KdOFZ-0001Q4-So@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-os (Dick Johnson) <linux-os@analogic.com> wrote:

> If you have to single-step through kernel procedures, you
> are not writing proper code for a kernel. Furthermore, even
> when using the kernel debugger, you are not executing the
> exact same path that would be executed without the debugger
> attached.

I sometimes single-step in order to verify my (userspace) code, instead of
just throwing random test data at it. It's easier and makes me feel better.
OTOH, -O2 never was a problem if I used it, so I don't strongly vote
for enabling -O0.

