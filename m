Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbZKOUxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbZKOUxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 15:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZKOUxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 15:53:39 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57214 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbZKOUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 15:53:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to &proc_dointvec,
Date: Sun, 15 Nov 2009 20:53:35 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Am??rico Wang" <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1258249925.16857.198.camel@Joe-Laptop.home> <1258313031.21668.73.camel@Joe-Laptop.home> <Pine.LNX.4.64.0911152139020.30372@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0911152139020.30372@ask.diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911152053.35292.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18FBkn6p1WS+3Q9TRzjAxlWo8t8FgASRXaMqZ8
 Ejhm94d0JoFxOwWFX8rfh5iaND/Dl402hYjHvzVx+6STIySL51
 48jHRRXnpj+IrM3ZT1nhA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 November 2009 20:40:25 Julia Lawall wrote:
> It would be possible to count the number of occurrences in a given file, 
> and then change the ones that have the less popular format, or a format 
> that occurs less than some percentage of time.

How many of the 600 files use both formats?

	Arnd <><
