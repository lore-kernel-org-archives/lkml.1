Return-Path: <linux-kernel-owner+w=401wt.eu-S1757088AbYDGI3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbYDGI3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbYDGI3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:29:08 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:7285 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbYDGI3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:29:01 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: joern@logfs.org
Subject: Re: [patch 1/15] Makefiles and Kconfig
Date: Mon, 7 Apr 2008 10:28:58 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
References: <20080401181308.512473173@logfs.org> <20080401181332.853833001@logfs.org>
In-Reply-To: <20080401181332.853833001@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071028.58362.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 1. April 2008 schrieb joern@logfs.org:
> --- linux-2.6.24logfs/fs/Kconfig~logfs	2008-03-24 12:39:10.190939342 +0100
> +++ linux-2.6.24logfs/fs/Kconfig	2008-04-01 19:48:18.517351063 +0200
[...]
> --- linux-2.6.24logfs/fs/Makefile~logfs	2008-03-24 12:39:10.190939342 
> +++ linux-2.6.24logfs/fs/Makefile	2008-03-24 12:40:08.127616634 +0100 
[...]
> --- /dev/null	2008-03-30 12:15:48.586669308 +0200
> +++ linux-2.6.24logfs/fs/logfs/Makefile	2008-04-01 19:48:07.170961891 
[...] 

Hi Joern,

can you make the Kconfig/Makefile changes the last patch? This will help git 
bisect. 

Christian
