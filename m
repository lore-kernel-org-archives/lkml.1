Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbYEaVqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbYEaVqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 17:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYEaVp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 17:45:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:45848 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbYEaVp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 17:45:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SZsdHe/jv66dejK+c3sSwaP/ucIpNvYFmN02GPqAZMnyTC5YgcqytDSrmiauQZnqdxvF/Lt/z8dge0nHCfqwDDCHWJ16tjF9cfXgVCGEEdebdZ62UjNrty8uDkP1YoMGrw/GMcpiHTpiHkwjoWrthEnC1v0clAlf2BdaThft+r0=
Message-ID: <a01a16b50805311445g23ea825t809fbace49f16d0d@mail.gmail.com>
Date: Sat, 31 May 2008 23:45:56 +0200
From: "=?UTF-8?Q?H=C3=A5kon_L=C3=B8vdal?=" <hlovdal@gmail.com>
To: "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805312332270.2760@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080526115628.GA31316@elte.hu> <1211966834.12349.62.camel@twins>
	 <a01a16b50805310725x4f1c375ep2d091bb044ac0787@mail.gmail.com>
	 <Pine.LNX.4.64.0805311839540.2657@wrl-59.cs.helsinki.fi>
	 <484191BD.8000904@gmail.com>
	 <Pine.LNX.4.64.0805312119270.2672@wrl-59.cs.helsinki.fi>
	 <a01a16b50805311325w7f58ca69h93d02af9bc28d2ea@mail.gmail.com>
	 <Pine.LNX.4.64.0805312332270.2760@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4VLkKHl001374

2008/5/31 Ilpo JÃ¤rvinen <ilpo.jarvinen@helsinki.fi>:> On Sat, 31 May 2008, HÃ¥kon LÃ¸vdal wrote:>> 2008/5/31 Ilpo JÃ¤rvinen <ilpo.jarvinen@helsinki.fi>:>> > So you had that '-' earlier and you checked at that time but the>> > connection is now already dead?>>>> This is only from checking after the connection was dead.>> Could you please rephrase the answer, I failed to understand it... :-)> ...You said earlier that you had '-' owned connections like Ingo, when did> that happen (now the connections won't exists anymore, so at what point of> time you saw those non-owned connections)?
What I mean is that I just tested "netstat -p" and noticed similaritieswith Ingo's result today while replying to this thread, which is daysafter the connections ended.
BR HÃ¥kon LÃ¸vdalÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
