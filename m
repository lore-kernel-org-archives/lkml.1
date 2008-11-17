Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYKQRoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYKQRoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbYKQRn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:43:57 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:61526 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbYKQRn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:43:56 -0500
Date: Mon, 17 Nov 2008 09:43:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/7] drivers/ata/pata_radisys.c: cleanup kernel-doc
Message-Id: <20081117094341.75ec0d7a.randy.dunlap@oracle.com>
In-Reply-To: <491feb5b.08486e0a.075a.4c48@mx.google.com>
References: <491feb5b.08486e0a.075a.4c48@mx.google.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4921AD52.0046:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 17:43:46 +0800 Qinghuang Feng wrote:

> No argument named @isich in radisys_set_dmamode,
> remove it.
> 
> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>

patches 1-7:
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

I'll leave them for Jeff to merge.

Thanks.

---
~Randy
