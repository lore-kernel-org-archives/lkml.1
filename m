Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbYF0Fxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbYF0Fxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYF0Fxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:53:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53619 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbYF0Fxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:53:37 -0400
Message-ID: <4864805E.3010407@pobox.com>
Date: Fri, 27 Jun 2008 01:53:34 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Matti Linnanvuori <mattilinn@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1.2.31] wan: add driver retina
References: <ca0148c30806240335t799ab518o2f7589f6d3282787@mail.gmail.com>
In-Reply-To: <ca0148c30806240335t799ab518o2f7589f6d3282787@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matti Linnanvuori wrote:
> The patch is on top of linux-next June 24:
> http://pcidriver.googlegroups.com/web/retina-1.2.31.patch?hl=en&gda=IAodQEQAAAD13nxGN0cierCNeIeJfDX5xXkFPvbRgqL6oDt-R_zhlWG1qiJ7UbTIup-M2XPURDSCRcGQDyno6jchG3K2xOQpIvUJau0VvnTEe9ncJ6VTfQ&gsc=eDZaJAsAAADBvYu52m-YgWqvwRZy0wen
> 
> Change log:
> Fixed ETH_ZLEN minimal packet size
> Added mmap(2) interface description

applied


