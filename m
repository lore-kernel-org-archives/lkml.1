Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbXLLSrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbXLLSrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbXLLSrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:47:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54311
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755275AbXLLSrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:47:08 -0500
Date: Wed, 12 Dec 2007 10:47:07 -0800 (PST)
Message-Id: <20071212.104707.125945677.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: netdev@vger.kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Net: Remove FASTCALL macro
From: David Miller <davem@davemloft.net>
In-Reply-To: <1197446943.5745.9.camel@brick>
References: <1197446943.5745.9.camel@brick>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Wed, 12 Dec 2007 00:09:03 -0800

> X86_32 was the last user of the FASTCALL macro, now that it
> uses regparm(3) by default, this macro expands to nothing.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Applied to net-2.6.25, thanks.
