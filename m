Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbYBRPFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbYBRPFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYBRPF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:05:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:33565 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYBRPF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:05:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=sTuB5GozxkH2BDibLJBosUvL9yaGJKEgBcwF0O5auPpqOsrr0F3QBbAYneU28LvzqY+6bB5tLYjy9lKeoeXBmKAp4KB94aSM2+7+lsd1GJOluRfc8RlEmQuEtXr1PoiQZtXzvCB+uvj0VZaN2fdRF9fK007lbf/x7FydmLB9xHY=
Message-ID: <63aa4aaa0802180705i76229711v8ed9fb2b1ea242df@mail.gmail.com>
Date: Mon, 18 Feb 2008 23:05:26 +0800
From: Ke <kecore@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PCI DMA address
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
      How can kernel get the PCI DMA address above 16MB or 64MB?
      I hope that the all PCI devices can use a dma address above
0x1000000 at a higher memory.

Thanks.
