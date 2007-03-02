Return-Path: <linux-kernel-owner+w=401wt.eu-S2992727AbXCBXO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992727AbXCBXO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992725AbXCBXO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:14:29 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54573 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992720AbXCBXO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:14:28 -0500
Message-ID: <45E8AFD2.3020904@garzik.org>
Date: Fri, 02 Mar 2007 18:14:26 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: dev_config does not need ap and adev passing
References: <20070302005615.4f53acb8@lxorguk.ukuu.org.uk>
In-Reply-To: <20070302005615.4f53acb8@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> It used to be impossible to get from ata_device to ata_port but that is
> no longer true. Various methods have been cleaned up over time but
> dev_config still takes both and most users don't need both anyway. Tidy
> this one up
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

applied to #upstream (2.6.22), since its not a bugfix


