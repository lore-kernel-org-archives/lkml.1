Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbZKYUi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbZKYUi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759135AbZKYUi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:38:26 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51033 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758813AbZKYUiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:38:25 -0500
Message-ID: <4B0D95C3.4020706@garzik.org>
Date: Wed, 25 Nov 2009 15:38:27 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 62/86] pata_pdc202xx_old: document known issues
References: <20091125170218.5446.13513.sendpatchset@localhost> <200911251852.40281.bzolnier@gmail.com> <4B0D71A4.6090001@garzik.org> <200911251929.45897.bzolnier@gmail.com>
In-Reply-To: <200911251929.45897.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 01:29 PM, Bartlomiej Zolnierkiewicz wrote:
> I think it is the best to leave up to the driver maintainer
> (once we find out who this person is, MAINTAINERS file still
> lacks info about PATA drivers in -rc8).


The important thing is taking two minutes to write a relevant comment, 
not determining who is wearing a crown on his head.

	Jeff


