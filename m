Return-Path: <linux-kernel-owner+w=401wt.eu-S933031AbZJMGUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbZJMGUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932739AbZJMGUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:20:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46857
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932581AbZJMGUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:20:46 -0400
Date: Mon, 12 Oct 2009 23:20:42 -0700 (PDT)
Message-Id: <20091012.232042.170805942.davem@davemloft.net>
To: mchan@broadcom.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, shmulikr@broadcom.com
Subject: Re: linux-next: net tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <C27F8246C663564A84BB7AB34397724217C978403F@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <20091013153308.af56910a.sfr@canb.auug.org.au>
	<C27F8246C663564A84BB7AB34397724217C978403F@IRVEXCHCCR01.corp.ad.broadcom.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Mon, 12 Oct 2009 22:14:22 -0700

> I think adding #include <net/ip6_checksum.h> will work.  Will send a
> patch right away.  Thanks.

Too slow, I already fixed this :-)
