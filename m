Return-Path: <linux-kernel-owner+w=401wt.eu-S1945988AbXBBQzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945988AbXBBQzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 11:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945987AbXBBQzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 11:55:50 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:49981 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945988AbXBBQzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 11:55:48 -0500
Message-ID: <45C36D10.3030809@garzik.org>
Date: Fri, 02 Feb 2007 11:55:44 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] pata_platform: fix devres conversion
References: <11692764264005-git-send-email-htejun@gmail.com> <45C0827C.2050207@garzik.org> <20070201060522.GK8606@htj.dyndns.org>
In-Reply-To: <20070201060522.GK8606@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> devres updates for pata_platform were dropped while merging devres
> patches due to merge conflict.  This is the updated version.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

applied 1-2


