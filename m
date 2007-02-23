Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbXBWKhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbXBWKhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932210AbXBWKhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:37:52 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44923 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932211AbXBWKhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:37:51 -0500
Message-ID: <45DEC3FC.3040202@garzik.org>
Date: Fri, 23 Feb 2007 05:37:48 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: test major version in ata_id_is_sata()
References: <20070215233411.GA10782@havoc.gtf.org> <45D4F03E.6040208@garzik.org> <20070221112508.GX1625@htj.dyndns.org>
In-Reply-To: <20070221112508.GX1625@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Test major version in ata_id_is_sata() not separately.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

applied


