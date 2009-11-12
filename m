Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZKLWGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZKLWGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbZKLWG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:06:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754751AbZKLWG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:06:27 -0500
Date: Thu, 12 Nov 2009 14:05:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Daniel Mack <daniel@caiaq.de>, Pavel Machek <pavel@ucw.cz>,
       David Newall <davidn@davidnewall.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
Message-Id: <20091112140546.303e7dd6.akpm@linux-foundation.org>
In-Reply-To: <4AFA603B.6000102@ladisch.de>
References: <4AF7D439.4030305@ladisch.de>
	<20091109091044.GX29442@buzzloop.caiaq.de>
	<4AF7DDC1.4090006@ladisch.de>
	<20091109095316.6283fbd6@lxorguk.ukuu.org.uk>
	<4AF7FC64.6030904@ladisch.de>
	<20091109114600.4d91b90e@lxorguk.ukuu.org.uk>
	<20091109145056.GB14091@buzzloop.caiaq.de>
	<4AF8582B.2000403@davidnewall.com>
	<20091109220944.GH14091@buzzloop.caiaq.de>
	<20091110210940.GA1590@ucw.cz>
	<20091110152605.fc8e760e.akpm@linux-foundation.org>
	<4AFA603B.6000102@ladisch.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 07:56:59 +0100
Clemens Ladisch <clemens@ladisch.de> wrote:

> [PATCH] vt: make the default cursor shape configurable
> 
> Make the default console cursor type configurable rather than
> hard-coding it.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

The changelog omitted the most important piece of information: the
reason why we're making this change to the kernel.

I could type that in myself, but writing people's changelog for them
gets a bit dull after the first few thousand.  Please send a new,
complete changelog for this patch.

