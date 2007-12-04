Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbXLDTKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbXLDTKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbXLDTKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:10:38 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52065 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbXLDTKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:10:37 -0500
Message-ID: <4755A629.4070604@garzik.org>
Date: Tue, 04 Dec 2007 14:10:33 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: peerchen <peerchen@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] ahci: add the Device IDs of MCP79 AHCI controller to
 ahci.c
References: <200712032220233286345@gmail.com>
In-Reply-To: <200712032220233286345@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

peerchen wrote:
> Add the device IDs of legacy mode of MCP79 AHCI controller to ahci.c
> 
> The patch base on kernel 2.6.24-rc3
> 
> Signed-off-by: Peer Chen <peerchen@gmail.com>

applied #upstream-fixes


