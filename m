Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbYADOJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbYADOJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 09:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYADOJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 09:09:11 -0500
Received: from proxy1.bredband.net ([195.54.101.71]:58767 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYADOJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:09:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AglXAJPMfUdT48OPRmdsb2JhbACBV4YPiCEBAQE3gSKZQQ
Message-ID: <477E3DEA.4070001@coderworld.net>
Date: Fri, 04 Jan 2008 15:08:42 +0100
From: Richard Jonsson <richie@coderworld.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: forcedeth: MAC-address reversed on resume from suspend
References: <477BFC71.7090002@coderworld.net> <20080102214843.GA19224@rhlx01.hs-esslingen.de> <20080102234209.GA10831@does.not.exist> <20080104034357.GA2113@atjola.homenet>
In-Reply-To: <20080104034357.GA2113@atjola.homenet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Björn Steinbrink skrev:
> Richard, could you give this a spin? And then we'd likely need someone
> to test that with kexec...
> 
> thanks,
> Björn

The patch you sent does the trick, works fine now, thanks!
I cannot test this with kexec as I barely know what it is, I'll leave 
that to someone else.

/ Richard
