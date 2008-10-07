Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYJGBIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYJGBIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759721AbYJGBDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:03:12 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:38883 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759066AbYJGBDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:03:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oI13hnB6HGBO4WBOBx79FdIbjXWjDYNbA4ZMmQIeC0GceKylx3jyiGKKSV6/t3P1QNpTtj2vH2CKy9G7Edfr3I0ZsIVVtd4P/eJieBuc+IHmgWQOf/yNQeMet//TBp8bHGwTjcYnxjOvz16OtQCiJ/NHujBc4kCEGJ0c1TYnoGE=  ;
X-YMail-OSG: ifnOmfMVM1nbKH4aLN9eV2HHS3cBnIL_uXk1UMAZp7gda8.tT2v60rhgSZhKScBGHqFKhBhRtnqYWkPGtYVeGWsJi8MRNhk.NpGjV.cE5_5K3mI1RszoZK_v0WvfhdlZ3g0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: me@felipebalbi.com
Subject: Re: [RFC][PATCH 2/5] OMAP SSI driver interface
Date: Mon, 6 Oct 2008 18:03:06 -0700
User-Agent: KMail/1.9.9
Cc: Carlos Chinea <carlos.chinea@nokia.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
References: <1223034606.32631.156.camel@groo.research.nokia.com> <1223034750-18690-2-git-send-email-carlos.chinea@nokia.com> <20081006232931.GE8273@frodo>
In-Reply-To: <20081006232931.GE8273@frodo>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810061803.06731.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 October 2008, Felipe Balbi wrote:
> looks much better and much easier to type: #include <linux/ssi.h>

Does this work on non-OMAP kernels?  If not, <mach/ssi.h> or
similar would seem more sensible ...

Agreed about there being way too many headers, too.
