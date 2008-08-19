Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYHSQbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYHSQbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYHSQbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:31:44 -0400
Received: from mercury.sdinet.de ([193.103.161.30]:39520 "EHLO
	mercury.sdinet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYHSQbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:31:43 -0400
Date: Tue, 19 Aug 2008 18:31:41 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Chen Pei Chao <jackie73@ms2.hinet.net>
cc: linux-kernel@vger.kernel.org, jackie.chen@foxconn.com
Subject: =?ISO-8859-8?Q?Re=3A_Is_there_linux_RAM_filesystem_with_a_fixed_amount_of_memory=3F=FE?=
In-Reply-To: <016201c90203$b12fff40$110afea9@acer44836bb3d7>
Message-ID: <alpine.DEB.1.10.0808191830260.21827@mercury.sdinet.de>
References: <016201c90203$b12fff40$110afea9@acer44836bb3d7>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, Chen Pei Chao wrote:

> Is there any RAM file system that use a fixed amount of memory at all times
> and will not grow and
> shrink dynamically like tmpfs?
> Thanks in advance.

There are the old-style ramdisk block-devices, which will just claim the 
specified amount of memory and can be formatted with any filesystem.

c'ya
sven

-- 

The Internet treats censorship as a routing problem, and routes around
it. (John Gilmore on http://www.cygnus.com/~gnu/)
