Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbXFMMmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbXFMMmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 08:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbXFMMmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 08:42:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55951 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbXFMMmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 08:42:31 -0400
Date: Wed, 13 Jun 2007 05:44:10 -0700
From: Greg KH <greg@kroah.com>
To: dougthompson@xmission.com
Cc: Dave Jones <davej@redhat.com>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 4/6] include linux pci_id-h add amd northbridge defines
Message-ID: <20070613124410.GA12558@kroah.com>
References: <20070612032553.GB19293@redhat.com> <830935.77535.qm@web50107.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <830935.77535.qm@web50107.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 10:10:58PM -0700, Doug Thompson wrote:
> So is the model of such placement to locate the #define near to the
> sole consumer of that item? 

Yes.

> And if used by others, to move it to the pci_ids.h file?

Yes.

thanks,

greg k-h
