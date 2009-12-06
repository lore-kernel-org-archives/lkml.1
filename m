Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbZLFCg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbZLFCg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 21:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbZLFCgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 21:36:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40826 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123AbZLFCgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 21:36:54 -0500
Message-ID: <4B1B193B.7080609@gmail.com>
Date: Sun, 06 Dec 2009 03:38:51 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 11/31] Constify struct file_operations for 2.6.32 v1
References: <4B198670.2000406@gmail.com> <4B198C43.50205@gmail.com> <4B19A333.5080103@gmail.com> <4B1A6B28.2020501@gmail.com>
In-Reply-To: <4B1A6B28.2020501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Apart you CCed hundreds of people

I looked up the maintainers of the patched files from the kernel sources
because I didn't know a better way to let everyone affected know.

> and mixed thousand things together into one patch,

I thought that the best way is to have one patch contain changes for
a single structure type only.
--
Emese







