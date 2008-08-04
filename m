Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYHDSTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYHDSTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbYHDSSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:18:14 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:2025 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbYHDSQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:16:03 -0400
X-BigFish: VPS-38(zz1432R98dR4015M1805M936fQzz10d3izzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <48974802.30108@am.sony.com>
Date: Mon, 4 Aug 2008 11:18:42 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] embedded: fix vc_translate operator precedence
References: <48937AAE.5070407@am.sony.com> <Pine.LNX.4.64.0808041028230.31424@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0808041028230.31424@vixen.sonytel.be>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Aug 2008 18:15:47.0611 (UTC) FILETIME=[1E5206B0:01C8F65E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> 	Hi Tim,
> 
> On Fri, 1 Aug 2008, Tim Bird wrote:
>> This patch was copied to the e-mail list previously for testing.  Now,
>> all reports confirm that it works, so this is an official post for
>> application.
> 
> The above paragraph is not part of the patch description and should not end up
> in the git history, so it should be below the first `---' and above the
> diffstat, i.e.

Noted for future patch submissions.

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

