Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055Ab0ASWM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0ASWM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970Ab0ASWMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:12:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34834
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754955Ab0ASWMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:12:25 -0500
Date: Tue, 19 Jan 2010 14:12:34 -0800 (PST)
Message-Id: <20100119.141234.151191622.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru,
       jmorris@namei.org, kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [NETLINK]: With opcode INET_DIAG_BC_S_LE dport was
 compared in inet_diag_bc_run()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B56291D.2000304@gmail.com>
References: <4B56291D.2000304@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Tue, 19 Jan 2010 22:50:21 +0100

> The s-port should be compared.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> I presume?

Yep, looks good.

Excellent catch, applied, thanks!
