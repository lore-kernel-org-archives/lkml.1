Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbXI0Mkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbXI0Mkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXI0Mkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:40:47 -0400
Received: from zakalwe.fi ([80.83.5.154]:38930 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbXI0Mkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:40:46 -0400
Date: Thu, 27 Sep 2007 15:40:45 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Subrata Modak <subrata@linux.vnet.ibm.com>, geoff@gclare.org.uk,
       Christoph Hellwig <hch@lst.de>
Subject: Re: Revised signalfd man-page
Message-ID: <20070927124045.GL3400@zakalwe.fi>
References: <46FB9FB9.8080201@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <46FB9FB9.8080201@gmx.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 02:19:05PM +0200, Michael Kerrisk wrote:
>     uint28_t  pad[\fIX\fP];  /* Pad size to 128 bytes (allow space
>                           additional fields in the future) */

I think you mean uint8_t..

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
