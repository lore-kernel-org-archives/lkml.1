Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbXD1OzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbXD1OzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 10:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965851AbXD1OzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 10:55:20 -0400
Received: from gw.goop.org ([64.81.55.164]:48279 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964810AbXD1OzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 10:55:18 -0400
Message-ID: <46336059.2090306@goop.org>
Date: Sat, 28 Apr 2007 07:55:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix PSE pagetable construction
References: <4632AE54.7030200@goop.org> <200704281225.15849.ak@suse.de> <46335A6B.7070504@goop.org>
In-Reply-To: <46335A6B.7070504@goop.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Well, can I just get rid of the whole chunk of code that it's in?  It's
> only for "testing".

...not that it matters because we're dropping this patch anyway.

    J

