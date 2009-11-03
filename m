Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZKCOha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZKCOha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZKCOha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:37:30 -0500
Received: from verein.lst.de ([213.95.11.210]:33424 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZKCOh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:37:29 -0500
Date: Tue, 3 Nov 2009 15:36:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ankit Jain <me@ankitjain.org>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fs: add missing compat_ptr handling for FS_IOC_RESVSP ioctl
Message-ID: <20091103143641.GA19758@lst.de>
References: <20091103104532.GA19670@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103104532.GA19670@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -4.901 () BAYES_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.

