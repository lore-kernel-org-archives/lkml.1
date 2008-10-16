Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbYJPLci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbYJPLci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbYJPLcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:32:31 -0400
Received: from ozlabs.org ([203.10.76.45]:37811 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbYJPLca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:32:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [Patch] kernel/kallsyms.c: fix double return's
Date: Thu, 16 Oct 2008 22:32:28 +1100
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <20081010094223.GA2925@hack.voiplan.pt>
In-Reply-To: <20081010094223.GA2925@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810162232.28678.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2008 20:43:03 Américo Wang wrote:
> Commit 6dd06c9fbe025f542bce4cdb91790c0f91962722 introduced double
> returns in the function kallsyms_lookup(), it's weird.
> The second one should be removed.
>
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>

Yeah, weird.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
