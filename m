Return-Path: <linux-kernel-owner+w=401wt.eu-S965241AbXBQMzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965241AbXBQMzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 07:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965255AbXBQMzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 07:55:53 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:48991 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965241AbXBQMzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 07:55:52 -0500
Message-ID: <45D6FB5F.8000108@gmail.com>
Date: Sat, 17 Feb 2007 13:55:59 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Mockern@yandex.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux tty driver question
References: <45D6D3A3.000001.04520@tide.yandex.ru> <45D6E094.8030006@gmail.com> <45D6E6B7.000003.09194@mfront8.yandex.ru>
In-Reply-To: <45D6E6B7.000003.09194@mfront8.yandex.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern napsal(a):
> Thank you, 
> 
> I have no problem with my tty driver, except one thing: it does not work with cat (but there are no problems to write,read from user space application). I'll try to follow your adwise to support cat. 

And where does it stuck? use ptrace (e.g. strace) to investigate.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
