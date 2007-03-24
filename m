Return-Path: <linux-kernel-owner+w=401wt.eu-S932314AbXCXRD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbXCXRD5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 13:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbXCXRD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 13:03:57 -0400
Received: from www17.your-server.de ([213.133.104.17]:1650 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314AbXCXRD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 13:03:56 -0400
Message-ID: <46055A3B.6050107@m3y3r.de>
Date: Sat, 24 Mar 2007 18:04:59 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-ide@vger.kernel.org
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323185022.GQ752@stusta.de>
In-Reply-To: <20070323185022.GQ752@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk schrieb:
> Subject    : second suspend to disk in a row results in an oops  (libata?)
> References : http://lkml.org/lkml/2007/3/17/43
> Submitter  : Thomas Meyer <thomas@m3y3r.de>
> Status     : unknown
>   

The problem is identified: http://lkml.org/lkml/2007/3/22/150



