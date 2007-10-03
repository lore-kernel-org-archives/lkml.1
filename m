Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbXJCVX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbXJCVX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbXJCVXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:23:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41352 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754904AbXJCVXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:23:49 -0400
Date: Wed, 3 Oct 2007 14:23:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: linux-kernel@vger.kernel.org, ryanr23@gmail.com
Subject: Re: [PATCH -mm] IrCOMM discovery indication simplification
Message-Id: <20071003142343.ecbb19a3.akpm@linux-foundation.org>
In-Reply-To: <20070930232951.GA18702@sortiz.org>
References: <20070930232951.GA18702@sortiz.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 02:29:51 +0300
Samuel Ortiz <samuel@sortiz.org> wrote:

> Hi Andrew,
> 
> Every IrCOMM socket is registered with the discovery subsystem, so we don't
> need to loop over all of them for every discovery event. We just need to
> do it for the registered IrCOMM socket.
> 
> Would you please consider this patch for -mm inclusion ?

Sure.  I don't merge ircomm patches directly so I added this to my
to-send-to-davem queue.

> From: Ryan Reading <ryanr23@gmail.com>
> Signed-off-by: Samuel Ortiz <samuel@sortiz.org>

Please put the From: right at the start of the changelog, not at the end
like this, thanks.


