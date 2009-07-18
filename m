Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbZGRBYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbZGRBYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 21:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbZGRBYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 21:24:10 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:62522 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbZGRBYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 21:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=xEvmhbW24H6HFX1AnyQDA4ka0XyzQaq1yTXWyK5nNiYXQ8YbgHbl1eWiEpiOGBbjkG
         BrddGExwuIw44ZE1OtVO7bZuRcj48OzBykCbqMvPnLFNIiGje7dzFCBICOJZwb+AuwYB
         DBWNHe5+KV8C48WN0iZyl8kmgd2hnBbiHm8AM=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 17 Jul 2009 18:15:40 -0700
Message-ID: <43e72e890907171815x3a85c788k1b4c0f72954db9e5@mail.gmail.com>
Subject: khttpd fate
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Ted Merrill <atheros@embuildsw.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was reviewing khttpd [1] history [2], and the last I see is it was
merged for the 2.4 kernel with enthusiasm. I don't see any information
about this for 2.6 though, nor can I find any other notes about why
this was removed. Just curious if someone recalls why it was removed.

Also, I really hate how trolly this questions sounds but here it goes anyway:

Such userspace-kernel hacks shouldn't be necessary anymore based on
'performance/latency' arguments right? I take it khttpd wasn't serious
but more of a hack for fun and now we should be able to laugh about
it?

[1] http://www.fenrus.demon.nl/
[2] http://lwn.net/2001/0118/kernel.php3

  Luis
