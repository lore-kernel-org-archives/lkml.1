Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbYEXSTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbYEXSTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761094AbYEXSTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:19:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47679 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759627AbYEXSTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:19:20 -0400
Message-ID: <48385AA6.7000604@zytor.com>
Date: Sat, 24 May 2008 11:12:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Steve French <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com> <20080524054301.GA3773@uranus.ravnborg.org> <4837AAE2.9090102@zytor.com> <20080524064201.GA4133@uranus.ravnborg.org> <4837E89D.9040008@goop.org> <20080524112704.GA7292@uranus.ravnborg.org> <483827CE.9080200@goop.org> <20080524153611.GA13890@uranus.ravnborg.org> <48383830.6060504@goop.org>
In-Reply-To: <48383830.6060504@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> I have to say I'm not very keen on the CFG_* prefix.  It doesn't have 
> any inherent meaning and just looks like a redundant abbreviation of 
> CONFIG_

Well, that's pretty much what it was meant to be.

	-hpa
