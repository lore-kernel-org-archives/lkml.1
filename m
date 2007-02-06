Return-Path: <linux-kernel-owner+w=401wt.eu-S1751569AbXBFIGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbXBFIGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXBFIGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:06:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:55499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXBFIGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:06:45 -0500
From: Andi Kleen <ak@suse.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH][0/5] floppy.c: first round of cleanup patches - the simple stuff
Date: Tue, 6 Feb 2007 09:06:42 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200702060028.31691.jesper.juhl@gmail.com>
In-Reply-To: <200702060028.31691.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702060906.42295.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 February 2007 00:28, Jesper Juhl wrote:
> Greetings people,
> 
> Here is, as promised, the first round of cleanup patches for floppy.c
> (more will follow later).

I think the real problem with floppy.c is the basic code logic,
not the coding style. While cleaning the later up is nice, I'm afraid 
it doesn't really help all that much because that code has to be
replaced anyways.

-Andi
