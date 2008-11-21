Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYKUTrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYKUTrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYKUTra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:47:30 -0500
Received: from ns1.suse.de ([195.135.220.2]:60774 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbYKUTr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:47:29 -0500
Date: Fri, 21 Nov 2008 11:01:11 -0800
From: Greg KH <gregkh@suse.de>
To: Lalit Chandivade <lalit.chandivade@qlogic.com>
Cc: Greg KH <greg@kroah.com>, Stefan Lippers-Hollmann <s.L-H@gmx.de>,
       James.Bottomley@hansenpartnership.com, stable@kernel.org,
       linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [stable]
	patchscsi-qla2xxx-correct-atmel-flash-part-handling.patch added
	to2.6.27-stable tree
Message-ID: <20081121190111.GB31017@suse.de>
References: <20081117055003.2F349145446A@imap.suse.de> <200811180154.49395.s.L-H@gmx.de> <20081118150903.GA1281@kroah.com> <07FCD974C26C22409200FA0D79291F05775799@AVEXCH1.qlogic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07FCD974C26C22409200FA0D79291F05775799@AVEXCH1.qlogic.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 09:21:12AM -0800, Lalit Chandivade wrote:
> Greg,
> 
> This change is missing, attached is the full patch, also pasted below.

Thanks for the fix, I used it in the 2.6.27.7 release.

greg k-h
