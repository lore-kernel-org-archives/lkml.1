Return-Path: <linux-kernel-owner+w=401wt.eu-S933216AbXAaMpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbXAaMpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933202AbXAaMpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:45:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49502 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174AbXAaMoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:44:55 -0500
Date: Wed, 31 Jan 2007 12:44:37 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Divy Le Ray <None@chelsio.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, swise@opengridcomputing.com
Subject: Re: [PATCH 1/10] cxgb3 - FW versioning
Message-ID: <20070131124437.GA26476@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, Divy Le Ray <None@chelsio.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	swise@opengridcomputing.com
References: <20070131034345.8574.21031.stgit@localhost.localdomain> <45C07202.3090308@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C07202.3090308@garzik.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 05:40:02AM -0500, Jeff Garzik wrote:
> honestly it looks like just about every ioctl except load-firmware should go

And while we're at it a load-firmware sounds like a nice addition for
ethtool aswell.  Or we may want to extent the firmware loader to deal with
updating firmware in addition to loading it to rom-less devices.

