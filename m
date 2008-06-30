Return-Path: <linux-kernel-owner+w=401wt.eu-S1760364AbYF3Q3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364AbYF3Q3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYF3Q2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:28:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:54818 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbYF3Q2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:28:51 -0400
In-Reply-To: <4117.6640-711-1819091302-1214810290@seznam.cz>
References: <4117.6640-711-1819091302-1214810290@seznam.cz>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <387e5af6a3d9efd2b982dbc32e8e0338@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: hpa@zytor.com, John.Linn@xilinx.com, arnd@arndb.de, drepper@redhat.com,
       matthew@wil.cx, john.williams@petalogix.com,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       linuxppc-dev@ozlabs.org, Michal Simek <monstr@monstr.eu>,
       vapier.adi@gmail.com, microblaze-uclinux@itee.uq.edu.au,
       linux-arch@vger.kernel.org, will.newton@gmail.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 19/60] microblaze_v4: checksum support
Date: Mon, 30 Jun 2008 18:25:08 +0200
To: Michal Simek <Monstr@seznam.cz>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> you find bug because there is microblaze asm code in generic folder.

No, I found it because I was reading the code, I didn't even notice
this was in asm-generic :-)

> Big thanks. I'll fix it and I'll look at parameters too.

Thanks.


Segher

