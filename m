Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZERW4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZERW4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 18:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZERW4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 18:56:13 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:33570 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172AbZERW4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 18:56:13 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net 911D22C2D49
From: Bodo Eggert <7eggert@web.de>
Subject: Re: super root shell/mode/api
To: Andrea <andrea256it@yahoo.it>, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Tue, 19 May 2009 00:56:12 +0200
References: <cCSbU-L3-17@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1M6Bki-0001ld-CQ@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea <andrea256it@yahoo.it> wrote:

> In order to be able to dump/terminate viruses, attacks and OOM processes an
> admin should have the possibility to *quickly* SIGSTP *all* processes except
> vga consoles and to switch from X11 to vga, maybe with SysRq.
> 
> Is this possible?

If there is a malware with root privileges, this would be of no use. You are
0wned.

If there is a malware with user privileges, stopping these processes will
be enough.

So why bother?

