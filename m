Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZBIQue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZBIQue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbZBIQuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:50:25 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43087 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZBIQuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:50:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ipOCpLIUWy4cE90qxvg7MDOFjzhCgV6biwPHsbLiz9Y5NhdkZhiprnSP73JS9PanWJ
         3NLOfYU/EribB/iAt+NZi2tGHrNX+QqTZgdgUEGanUm1PrX5w5CJ97WxIdqIx40i/9jC
         H9BfQ9UdsyemDYOAFoWiDOKQk35+5qL/Zsc0E=
MIME-Version: 1.0
In-Reply-To: <1234191743.3156.2.camel@localhost.localdomain>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <1234191743.3156.2.camel@localhost.localdomain>
Date: Mon, 9 Feb 2009 17:50:23 +0100
Message-ID: <cb7bb73a0902090850m1abb0f74wc75d77df8a507852@mail.gmail.com>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 4:02 PM, Jaswinder Singh Rajput
<jaswinder@kernel.org> wrote:
> On Sat, 2009-02-07 at 01:48 +0100, Giuseppe Bilotta wrote:
>> Add support for HP Pavlion dv5 models, whose sensor has an inverted x
>> axis.
>>
> How can I test this patch on HP dv5-1002us laptop.

lspnp (run by root, most likely) should show a device HPQ0004. If it's
present you have the sensor. I also have a big horrible sticker on my
palm rest advertising the protectsmart feature.

(Please use Reply-All)

-- 
Giuseppe "Oblomov" Bilotta
