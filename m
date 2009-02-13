Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbZBMS56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbZBMS56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760807AbZBMS5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:57:42 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:40485 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760793AbZBMS5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:57:41 -0500
Date: Fri, 13 Feb 2009 13:56:54 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Philippe Grenard <philippe.grenard@laposte.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel
In-reply-to: <200902131944.56634.philippe.grenard@laposte.net>
Message-id: <alpine.LFD.2.00.0902131356010.5440@localhost.localdomain>
References: <200902131944.56634.philippe.grenard@laposte.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmesg -- assuming you can boot far enough to capture it,
may be helpful.

also, disabling PREEMPT may be interesting to try.

cheers,
--
Len Brown, Intel Open Source Technology Center

