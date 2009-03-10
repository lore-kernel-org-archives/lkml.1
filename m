Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbZCJSvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbZCJSvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZCJSvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:51:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:5942 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbZCJSvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:51:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,337,1233561600"; 
   d="scan'208";a="118813106"
From: =?iso-8859-1?q?I=F1aky_P=E9rez-Gonz=E1lez?= 
	<inaky.perez-gonzalez@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -mmotm] wimax: fix i2400m printk formats
Date: Tue, 10 Mar 2009 11:51:03 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
References: <20090309162718.e38a7299.randy.dunlap@oracle.com>
In-Reply-To: <20090309162718.e38a7299.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903101151.03325.inaky.perez-gonzalez@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 March 2009, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix printk format warnings:
>
> drivers/net/wimax/i2400m/netdev.c:523: warning: format '%zu' expects type
> 'size_t', but argument 7 has type 'unsigned int'
> drivers/net/wimax/i2400m/netdev.c:548: warning: format '%zu' expects type
> 'size_t', but argument 7 has type 'unsigned int'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>

Applied, thanks
