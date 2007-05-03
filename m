Return-Path: <linux-kernel-owner+w=401wt.eu-S1161834AbXECLoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161834AbXECLoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030800AbXECLoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:44:21 -0400
Received: from [212.12.190.49] ([212.12.190.49]:33124 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031047AbXECLoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:44:20 -0400
From: Al Boldi <a1426z@gawab.com>
To: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
Subject: Re: Execute in place
Date: Thu, 3 May 2007 14:33:09 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200705030211.36293.a1426z@gawab.com> <46398FCF.80100@gmail.com>
In-Reply-To: <46398FCF.80100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705031433.09364.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Krivoschekov wrote:
> Al Boldi wrote:
> > Now, if there were only an easy way to make tmpfs persistent?
>
> It would be not a tmpfs (*temporary* fs)then,

Isn't everything really just temporary?

> but something like this
>
> http://pramfs.sourceforge.net/

Thanks a lot, but this seems to rely on a non-volatile RAM.

Would something like an mmap'd tmpfs be possible?


Thanks!

--
Al

