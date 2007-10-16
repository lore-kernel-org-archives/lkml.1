Return-Path: <linux-kernel-owner+w=401wt.eu-S1765384AbXJPDml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765384AbXJPDml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 23:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764933AbXJPDma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 23:42:30 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:63454 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757372AbXJPDm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 23:42:29 -0400
Message-ID: <jwvwstnzpx6.fsf-monnier+inbox@gnu.org>
To: 7eggert@gmx.de
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Killing a network connection
References: <9eFcS-It-3@gated-at.bofh.it> <9eGsi-2Sr-35@gated-at.bofh.it>
	<E1IhZi3-0001Hd-Ug@be1.lrz>
From: Stefan Monnier <monnier@iro.umontreal.ca>
Date: Mon, 15 Oct 2007 23:42:27 -0400
In-Reply-To: <E1IhZi3-0001Hd-Ug@be1.lrz> (Bodo Eggert's message of "Tue\, 16 Oct 2007 01\:50\:55 +0200")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There is a /proc/sys/net/ipv4/ip_dynaddr sysctl in 2.6.21.

Actually, it does look promising, thanks.


        Stefan
