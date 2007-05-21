Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbXEUR1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbXEUR1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbXEUR1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:27:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbXEUR1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:27:13 -0400
Date: Mon, 21 May 2007 13:27:08 -0400
From: Dave Jones <davej@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org
Subject: Re: Add Seagate STT20000A to DMA blacklist.
Message-ID: <20070521172708.GF9653@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>, bzolnier@gmail.com,
	linux-ide@vger.kernel.org
References: <20070521145042.GA6957@redhat.com> <20070521171551.0f81a0be@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521171551.0f81a0be@the-village.bc.nu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 05:15:51PM +0100, Alan Cox wrote:
 > On Mon, 21 May 2007 10:50:42 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > http://bugzilla.kernel.org/show_bug.cgi?id=1044
 > > has been open for _four_ years with a patch available.
 > > Here's a rediffed version of the same.
 > 
 > Please update libata as well when you udpate the blacklists.

Sure, point me at the table(s) ?

	Dave

-- 
http://www.codemonkey.org.uk
