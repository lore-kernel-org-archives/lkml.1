Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZK3TkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZK3TkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZK3TkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:40:18 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39873 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbZK3TkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:40:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WnezsHenDmh+QJVsWGcblSSQLAIrmP6Q7N+cF5nWeCybJjJY+JIskAMBynUz8ktGHt
         sFKV/cbphP9anA6d7Cu1ycqrij2kMaVVduR5Ww7pdOyoGeccz/u09YyLETOfT/kjBKKo
         JPFazR4i5bfByk7hfh1/KWfnD7BXALS2+7igA=
Message-ID: <4B141F8B.4040001@gmail.com>
Date: Mon, 30 Nov 2009 20:39:55 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: William Allen Simpson <william.allen.simpson@gmail.com>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: warning: massive change to conditional coding style in net?
References: <4B13A025.7000103@gmail.com>	<20091130134414.GB7114@ff.dom.local> <20091130135435.3895a437@lxorguk.ukuu.org.uk>
In-Reply-To: <20091130135435.3895a437@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote, On 11/30/2009 02:54 PM:

>>> Miller (with Perches) changed hundreds (thousands?) of these to
>>> trailing form.  This results in a number of hilarious examples --
>>> lines with both leading and trailing, lines with only &&, etc.  A
>>> small sample for illustration:
>> Yes, it's even enough to make a grown man laugh....
> 
> IMHO for left to right languages dangly bits want to be on the right,
> because that is where your eyes are when you hit the end of the previous
> line, so the dangly bit is already in your line of vision and probably
> even in focus.

Of course this is right. Plus "IMHO" "habit is the second nature", so
riding the same side of the road helps, even if it's the wrong side. ;-)

Jarek P.

