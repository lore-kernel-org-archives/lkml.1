Return-Path: <linux-kernel-owner+w=401wt.eu-S964781AbXBPMry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781AbXBPMry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 07:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964787AbXBPMry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 07:47:54 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:51322 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964781AbXBPMrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 07:47:53 -0500
Message-ID: <45D5A7FE.7010309@gmail.com>
Date: Fri, 16 Feb 2007 13:47:58 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Mockern@yandex.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: bloc_til_ready in tty driver
References: <45D5A1E0.000004.21866@tide.yandex.ru>
In-Reply-To: <45D5A1E0.000004.21866@tide.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern napsal(a):
> What for is "bloc_til_ready" function in tty drivers?

Most drivers waits for hardware to detect carrier and for closed callout.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
