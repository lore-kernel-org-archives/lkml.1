Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbZBMOmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbZBMOmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbZBMOmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:42:13 -0500
Received: from matrixpower.ru ([195.178.208.66]:36356 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbZBMOmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:42:13 -0500
Date: Fri, 13 Feb 2009 17:42:09 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next 2/2] pohmelfs: fix printk format warnings
Message-ID: <20090213144209.GB28569@ioremap.net>
References: <20090213125944.GB7003@orion> <20090213131400.GF23879@ioremap.net> <a4423d670902130637h8a7addfgd1ddb8fb590dc507@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670902130637h8a7addfgd1ddb8fb590dc507@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 05:37:28PM +0300, Alexander Beregalov (a.beregalov@gmail.com) wrote:
> > Doesn't size_t have %zu format?
> Hi
> 
> Thanks for the tip, may I rewrite the patch?

Sure :)
Thank you.

-- 
	Evgeniy Polyakov
