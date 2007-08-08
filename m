Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbXHHGKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbXHHGKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 02:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXHHGKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 02:10:21 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:55166 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbXHHGKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 02:10:20 -0400
Date: Wed, 8 Aug 2007 08:10:31 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] remove binfmts.h from header exports
Message-ID: <20070808061031.GA1126@aepfle.de>
References: <20070807201603.GB31501@aepfle.de> <46B901BD.4040405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46B901BD.4040405@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, Rene Herman wrote:

> >No package uses linux/binfmts.h, so it is safe to not provide it.
> 
> How is "all packages" defined?

3052 openSuSE 10.3 packages.
