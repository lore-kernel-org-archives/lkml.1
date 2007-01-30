Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbXA3ABF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbXA3ABF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXA3ABF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:01:05 -0500
Received: from terminus.zytor.com ([192.83.249.54]:54576 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbXA3ABD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:01:03 -0500
Message-ID: <45BE8AAA.9020308@zytor.com>
Date: Mon, 29 Jan 2007 16:00:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Kevin Nicoll <blort128@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Multiple ip= boot arguments?
References: <e4fa6c610701291036r7ff384e4u78d3995ab3d042d8@mail.gmail.com> <Pine.LNX.4.61.0701292146470.5077@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0701292146470.5077@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
>> or if I'm supposed to use a startup script instead.
> 
> This is the preffered way nowadays. One day, hopefully,
> CONFIG_IP_PNP can go away.
> 

It could be done reasonably easy, you know... :-/

	-hpa
