Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbXDDOtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbXDDOtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbXDDOtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:49:23 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:48468 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbXDDOtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:49:22 -0400
Subject: Re: MODULE_MAINTAINER
From: Marcel Holtmann <marcel@holtmann.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Rene Herman <rene.herman@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070404123311.GA18552@infradead.org>
References: <46138B4C.2050409@gmail.com>
	 <20070404123311.GA18552@infradead.org>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 16:48:55 +0200
Message-Id: <1175698135.5815.447.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

> > Can we have a MODULE_MAINTAINER to complement MODULE_AUTHOR?
> 
> #define MODULE_MAINTAINER(x) MODULE_AUTHOR(x), please.
> MODULE_AUTHOR really has meant maintainer in practice for ages, and it's
> the only actually relevant for users information we should store.

I agree. The actual author information belong into the files copyright
header. The MODULE_AUTHOR should only show the current maintainer and
its email address. However this might need some cleanup. Maybe it is
time that we sync the MAINTAINERS file with the MODULE_AUTHOR tag.

Regards

Marcel


