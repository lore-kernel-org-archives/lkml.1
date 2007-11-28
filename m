Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbXK1Sd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbXK1Sd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXK1Sdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:33:52 -0500
Received: from sacred.ru ([62.205.161.221]:56324 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbXK1Sdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:33:51 -0500
Message-ID: <474DA549.6060408@openvz.org>
Date: Wed, 28 Nov 2007 20:28:41 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch -mm 0/4] mqueue namespace
References: <20071128163728.177495768@fr.ibm.com>>
In-Reply-To: <20071128163728.177495768@fr.ibm.com>>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 28 Nov 2007 20:28:40 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater wrote:
> Hello ! 
> 
> Here's a small patchset introducing a new namespace for POSIX
> message queues. 
> 
> Nothing really complex a part from the mqueue filesystem which 
> needed some special care

Hm... Why did you decided to make it separately from the
IPC namespace?

> Thanks for reviewing !
> 
> C.
> 

