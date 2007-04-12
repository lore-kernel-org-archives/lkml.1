Return-Path: <linux-kernel-owner+w=401wt.eu-S1030603AbXDLRuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030603AbXDLRuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030621AbXDLRuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:50:19 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030603AbXDLRuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:50:18 -0400
Message-ID: <461E713F.3090603@zytor.com>
Date: Thu, 12 Apr 2007 10:49:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Egmont Koblinger <egmont@uhulinux.hu>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
References: <20070410183659.7341eeec@the-village.bc.nu> <20070411182801.GC26382@uhulinux.hu> <461D2AB8.5080902@zytor.com> <20070412091120.GA15666@uhulinux.hu> <461E5212.8070807@zytor.com> <Pine.LNX.4.61.0704121840350.14441@yvahk01.tjqt.qr> <20070412165540.GB21576@uhulinux.hu> <461E653E.6020400@zytor.com> <20070412171606.GA24756@uhulinux.hu> <461E6DDC.7050202@zytor.com> <20070412174443.GA26002@uhulinux.hu>
In-Reply-To: <20070412174443.GA26002@uhulinux.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Egmont Koblinger wrote:
> On Thu, Apr 12, 2007 at 10:35:24AM -0700, H. Peter Anvin wrote:
> 
>> Yes, I didn't realize at the time that that was dead code.
> 
> :-))))
> 
> Version 4 of the patch follows. Dead code omitted from version 3.

Looks good to me.

	-hpa
