Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbZLBSWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbZLBSWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 13:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbZLBSWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 13:22:49 -0500
Received: from kroah.org ([198.145.64.141]:51059 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbZLBSWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 13:22:48 -0500
Date: Wed, 2 Dec 2009 10:18:49 -0800
From: Greg KH <greg@kroah.com>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/11] ldisc n_tty: export all N_TTY ldisc methods.
Message-ID: <20091202181849.GA24410@kroah.com>
References: <1259774329-29663-1-git-send-email-giometti@linux.it>
 <1259774329-29663-2-git-send-email-giometti@linux.it>
 <1259774329-29663-3-git-send-email-giometti@linux.it>
 <1259774329-29663-4-git-send-email-giometti@linux.it>
 <1259774329-29663-5-git-send-email-giometti@linux.it>
 <1259774329-29663-6-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259774329-29663-6-git-send-email-giometti@linux.it>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 06:18:43PM +0100, Rodolfo Giometti wrote:
> Signed-off-by: Rodolfo Giometti <giometti@linux.it>

Why make this change?

(hint, I think I know why, but you need to spell it out in the changelog
comments...)

thanks,

greg k-h
