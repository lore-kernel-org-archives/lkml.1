Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYFAPJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYFAPJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 11:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYFAPJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 11:09:08 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:40816 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYFAPJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 11:09:07 -0400
Message-ID: <4842BB89.5090908@diamondcut.com.br>
Date: Sun, 01 Jun 2008 12:08:57 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Bug 10797] Something is consuming power after shutdown
References: <483AB443.6020807@diamondcut.com.br> <20080531074433.GE5405@ucw.cz>
In-Reply-To: <20080531074433.GE5405@ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Renato S. Yamane wrote:
> ...
>> <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
>> <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=481493>
>
> Try to find out which component eats power, eg. by opening the machine
> searching for heat.
> 
> (And yes, your hw is broken; on pc it is traditionaly hw
> responsibility to power machine down.)

OK, I try do this but I think this is very difficult because demand
power is very low and is not enought to do hot some component. But I
will try.

I don't think that my hardware is broked because I don't have this kind
of problem on Kernel <=2.6.22 or in other OS.

And other user have the same problem (cc'ed on Bug #10797)

Best regards,
Renato S. Yamane
