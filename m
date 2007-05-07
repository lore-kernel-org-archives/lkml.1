Return-Path: <linux-kernel-owner+w=401wt.eu-S966880AbXEGVsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966880AbXEGVsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966354AbXEGVr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:47:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966651AbXEGVr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:47:56 -0400
Message-ID: <463F9DFF.7010101@redhat.com>
Date: Mon, 07 May 2007 16:45:35 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, sam@ravnborg.org
Subject: Re: [PATCH] [KBUILD] fix external module install path
References: <463F9C3B.4080004@sandeen.net>
In-Reply-To: <463F9C3B.4080004@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Installing external modules is supposed to put them in some path
> under /lib/modules/<version>/extra/subdir/, but this change:
> http://linux.bkbits.net:8080/linux-2.6/?PAGE=cset&REV=1.1982.9.23
> makes them go under /lib/modules/<version>/extrasubdir

er, hang on.  Now it's not doing it ;-)  stay tuned.

Sorry... I really did get an "extrafs/" directory somehow :)

-Eric
