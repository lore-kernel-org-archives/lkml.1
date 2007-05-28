Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbXE1KQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbXE1KQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761033AbXE1KQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:16:42 -0400
Received: from 3404ds2-brh.0.fullrate.dk ([90.184.3.208]:11553 "EHLO
	mail.jaquet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbXE1KQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:16:40 -0400
Date: Mon, 28 May 2007 12:16:39 +0200
From: Rasmus Andersen <rasmus@jaquet.dk>
To: linux-kernel@vger.kernel.org
Subject: Re: RAID1 questions and errors and questions about errors :)
Message-ID: <20070528101639.GW11507@jaquet.dk>
References: <20070528095755.GU11507@jaquet.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528095755.GU11507@jaquet.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 11:57:55AM +0200, Rasmus Andersen wrote:
> My main problem is that a check/repair run of my RAID1 device reports
> errors. Not always the same number of errors and not monotonously
> increasing. It has not always been like this but I have not been able to
> link this to any external event.

Meh. I forgot to state that I have seen this with vanilla .20 and .21.1
and also with various gentoo kernels based on .20. But as stated, I am
not able to link this to a kernel upgrade.

Rasmus
