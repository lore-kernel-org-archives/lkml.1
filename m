Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbYETIQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbYETIQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbYETIPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:15:55 -0400
Received: from mail.mindmedia.com.sg ([210.193.7.34]:40158 "EHLO
	mail.mindmedia.com.sg" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755736AbYETIPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:15:53 -0400
Message-ID: <483288B1.3060102@singnet.com.sg>
Date: Tue, 20 May 2008 16:15:45 +0800
From: "P.V.Anthony" <pvantony@singnet.com.sg>
User-Agent: Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-kernel@vger.kernel.org
Subject: Re: Solved - How to change the FSINFO for nfsd?
References: <482332CD.4010706@singnet.com.sg> <20080509042238.GC21408@fieldses.org> <20080518015733.o7n8cvhomvgos8ow@mail.mindmedia.com.sg> <alpine.LNX.1.10.0805172024440.15590@fbirervta.pbzchgretzou.qr> <1211049402.7498.4.camel@localhost> <20080519172412.GL7622@fieldses.org>
In-Reply-To: <20080519172412.GL7622@fieldses.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using xfs filesystem on a gentoo 64bit linux with 2.6.22 kernel,
when mounting the FSINFO return got was 7f ff ff ff ff ff ff ff.

Assuming that xfs is 64bit,
the FSINFO returned is still not ff ff ff ff ff ff ff ff.

Used wireshark to see the FSINFO return.

P.V.Anthony
