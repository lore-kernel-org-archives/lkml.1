Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbYCIQQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbYCIQQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 12:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYCIQQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 12:16:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34004 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYCIQQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 12:16:37 -0400
Date: Sun, 9 Mar 2008 17:16:36 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Kyle Rose <krose@krose.org>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
Subject: Re: READDIRPLUS max mount option
In-Reply-To: <47D1ADC5.1050108@krose.org>
Message-ID: <Pine.LNX.4.64.0803091713440.26142@fbirervta.pbzchgretzou.qr>
References: <47D1995E.6060501@krose.org>  <1204919978.16746.12.camel@heimdal.trondhjem.org>
  <47D1A0F5.2070501@krose.org> <1204922570.16746.37.camel@heimdal.trondhjem.org>
 <47D1ADC5.1050108@krose.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 7 2008 16:04, Kyle Rose wrote:
>> Since we're talking about what is really a quite arbitrary limit, I can
>> certainly see an argument for why we might want a way to change it, but
>> I'm still not convinced that we need to be setting this parameter at the
>> mountpoint level.
>
> Fair enough.  A proc entry to alter this globally would be an acceptable
> compromise for me, even if my local sysadmins might not like it.
>
sysfs, no? A module parameter is easy for a global default and is
the minimum thing to do :)
