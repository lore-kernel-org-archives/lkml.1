Return-Path: <linux-kernel-owner+w=401wt.eu-S965012AbYBAAnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012AbYBAAnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 19:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759409AbYBAAn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 19:43:26 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:33636 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbYBAAnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:43:25 -0500
Message-ID: <47A26B2F.8080001@davidnewall.com>
Date: Fri, 01 Feb 2008 11:13:27 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: add a crc32 checksum to the kernel image.
References: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk> <1201815920-24669-2-git-send-email-ijc@hellion.org.uk> <1201815920-24669-3-git-send-email-ijc@hellion.org.uk>
In-Reply-To: <1201815920-24669-3-git-send-email-ijc@hellion.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't a crc32 calculation already defined?  Yes; in lib/crc32.c.  One is
surely enough.
