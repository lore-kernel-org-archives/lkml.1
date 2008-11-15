Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYKORWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYKORWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 12:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYKORWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 12:22:45 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:53236 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYKORWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 12:22:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rCSq+q48aHr5+Y9n3D5ayNj+bfYbCLvWC62cKpKs8BwGVQFxL//NT0N0dK/RNYBeIT
         OfH2oMQVxVePippa7xKfcC7rtjheVthX4kmlFqa6QsuQq23jZStJd4VE/dXwy35VL1Bc
         toejx8waKBuKRfDgpUi4FbKKMZp8l0e62aTR8=
Message-ID: <2375c9f90811150922x21e41faevcd7f1e9af45426e3@mail.gmail.com>
Date: Sat, 15 Nov 2008 17:22:42 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH 4/5] x86: ia32_signal: remove using temporary variable
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <491E41C3.9010500@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491E4101.7010405@ct.jp.nec.com> <491E41C3.9010500@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 3:28 AM, Hiroshi Shimamoto
<h-shimamoto@ct.jp.nec.com> wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> Impact: cleanup
>
> No need to use temporary variable.
> Also rename the variable same as kernel/signal_32.c.


I think you mean arch/x86/kernel/signal_32.c, of course. :-)

>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Reviewed-by: WANG Cong <wangcong@zeuux.org>
