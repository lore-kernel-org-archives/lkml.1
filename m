Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYAGDg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYAGDg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 22:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYAGDgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 22:36:20 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:1514 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbYAGDgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 22:36:19 -0500
From: Roman Zippel <zippel@linux-m68k.org>
To: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] UPDATED2: hfs: handle more on-disk corruptions without oopsing
Date: Mon, 7 Jan 2008 04:13:36 +0100
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <47699C29.4010706@redhat.com> <200712240316.43308.zippel@linux-m68k.org> <477BCC1F.5@redhat.com>
In-Reply-To: <477BCC1F.5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801070413.37288.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 2. January 2008, Eric Sandeen wrote:

> Roman, with this on top does it look better to you?

Looks good, thanks.

> I'll get hfsplus done in a bit.

I'm mainly concerned about brec.c/bfind.c, the patch should be pretty much 
identical.

bye, Roman
