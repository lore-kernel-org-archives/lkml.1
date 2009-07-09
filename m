Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbZGIEos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbZGIEos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 00:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbZGIEoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 00:44:39 -0400
Received: from fmailhost03.isp.att.net ([207.115.11.53]:59606 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZGIEoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 00:44:38 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A5575C1.8090403@lwfinger.net>
Date: Wed, 08 Jul 2009 23:44:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Linux wireless <linux-wireless@vger.kernel.org>,
       Przemyslaw Kulczycki <azrael@autocom.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] wireless: fix supported cards for rtl8187
References: <4A54FB81.30302@gmail.com>	 <3ace41890907081449m3ad6c4fdt55781848eedaec1e@mail.gmail.com>	 <4A551B43.3020104@gmail.com> <3ace41890907082118h52764c98i7ebd9365bcd69b2c@mail.gmail.com>
In-Reply-To: <3ace41890907082118h52764c98i7ebd9365bcd69b2c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hin-Tak Leung wrote:
> 
> if they are not labelled v1/v2/v3 as such, it may be more
> useful/informative to change to
> 
>     [some variant of ] ... [(other variants are supported by the
> rt2070/rt3070 modules)]
> 
> instead of just adding [v2] to the end.

I don't know about the box as I bought mine used on Ebay, but the
label on the device clearly states that it is a WG111v2.

Larry

