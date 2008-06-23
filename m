Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbYFWP0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbYFWP0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 11:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757873AbYFWP0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 11:26:42 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:24497 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193AbYFWP0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D9y/D3fiWwn90td5jKtCrga2ixJNzVahLXbm8lC1+RhuE1u3mMxfWf9V591EgW287O
         UITLGtclbZLVJUJDlQE0nnPuu/zNpWpONkjWrCmMUbNysJpO6FxcVCOzSz1QWv3WK57I
         9J3OD7Ll8FTCwsKlFGI9uDhG/i2nQNZpntcwc=
Message-ID: <b6a2187b0806230826q5131647j635e981163ffcb0c@mail.gmail.com>
Date: Mon, 23 Jun 2008 23:26:39 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: Linux 2.6.26-rc7
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, ecollins@vmware.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       support@vmware.com
In-Reply-To: <20080622095837.6f396327@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0806201626140.3167@woody.linux-foundation.org>
	 <b6a2187b0806220012t118d85ffp671abf715c14ea94@mail.gmail.com>
	 <20080622095837.6f396327@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 12:58 AM, Arjan van de Ven <arjan@infradead.org> wrote:

> is this the open source vmware guest modules, the proprietary vmware
> guest modules or the proprietary "vmware as host" kernel stuff ?

I believe this is the proprietary "vmware as host" binary since
vmmonPosix.c is no where to be found.

The open source vmware guest module doesn't work with vmware 6.0.4 so
I've to use the proprietary vmware guest module compiled to run on
2.6.26-rc7.

Thanks,
Jeff.
