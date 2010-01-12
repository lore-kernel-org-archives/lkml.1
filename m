Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608Ab0ALLvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab0ALLvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 06:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299Ab0ALLvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 06:51:19 -0500
Received: from ozlabs.org ([203.10.76.45]:41594 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab0ALLvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 06:51:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH] Add __devexit_p around reference to virtio_pci_remove
Date: Tue, 12 Jan 2010 21:38:41 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20100108220143.GA2133@shareable.org>
In-Reply-To: <20100108220143.GA2133@shareable.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001122138.41301.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jan 2010 08:31:43 am Jamie Lokier wrote:
> This is needed to compile with CONFIG_VIRTIO_PCI=y,
> because virtio_pci_remove is marked __devexit.

Thanks applied.

Rusty.
