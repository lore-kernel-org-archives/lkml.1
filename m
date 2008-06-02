Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYFBGgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYFBGgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYFBGgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:36:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:56261 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYFBGgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:36:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Acv7Y57j9s9bFHUx+7qfFxjg748+IJ0VMoFv/gSTonEb+VFelmgvNpAV20fGwdk9Dx0qnP6q1vpKft9ZBpIlO5h6ajwgZ4/uZjdklWA0j8ZXfFxbwH6ubX0UQW9+xpyfe2lP0ldkXXaVAwm50JpfE2xhAtGyD97fG7CFWxOEdlg=
Message-ID: <eb3ff54b0806012336s687b0d89t767c31615d955c61@mail.gmail.com>
Date: Mon, 2 Jun 2008 09:36:35 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH net-2.6 0/2] [IPV4] [NETFILTER] Misc Cleanups.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  While probing into IPV4 netfilter code, I came across these cleanups in
  net/ipv4/netfilter/ip_queue.c and in
include/net/netfilter/ipv4/nf_conntrack_ipv4.h.

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>
