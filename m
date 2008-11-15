Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYKORPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYKORPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 12:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYKORPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 12:15:16 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:37632 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYKORPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 12:15:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j+fCb5Wjw1Wz6ge9umtlySb4g9JhZVzTcK7R83kzXpCvKU3UqX9lLjc7vHnhXtCu65
         4xsaofLOlE87PV/Pll6sKVAHyfAWH5fcv8f8af5w0OUFG74pGpJ+S1vZjqDKTT0VolLX
         pmNW5CGOiRkp6ZEMCdlQNNjZkDdI6Y734O9dk=
Message-ID: <2375c9f90811150915q73bcec74t2464bd2b21301a51@mail.gmail.com>
Date: Sat, 15 Nov 2008 17:15:13 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH 3/5] x86: ia32_signal: cleanup macro RELOAD_SEG
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <491E4198.8070103@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491E4101.7010405@ct.jp.nec.com> <491E4198.8070103@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 3:27 AM, Hiroshi Shimamoto
<h-shimamoto@ct.jp.nec.com> wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> Impact: cleanup
>
> Remove mask parameter because it's always 3.


It also contains some style cleanups. :)

>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

If you need, you can add:

Reviewed-by: WANG Cong <wangcong@zeuux.org>
