Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbZFOFuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbZFOFuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 01:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbZFOFub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 01:50:31 -0400
Received: from ozlabs.org ([203.10.76.45]:35506 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZFOFua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 01:50:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: Re: [PATCH] cpumask: Remove mask field from comments
Date: Mon, 15 Jun 2009 15:20:27 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4A35BD26.1090906@renesas.com>
In-Reply-To: <4A35BD26.1090906@renesas.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906151520.27413.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 12:46:54 pm Nobuhiro Iwamatsu wrote:
> Subject: [PATCH 1/2] cpumask: Remove mask field from comments
>
> By 7be23e278f, mask field was deleted by irqaction. However, it was not
> deleted from comment.

Thanks, applied!

Rusty.
