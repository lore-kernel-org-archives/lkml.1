Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbZFOOlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbZFOOlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZFOOln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:41:43 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:36915 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZFOOlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:41:42 -0400
Message-ID: <4A365DA6.8000102@msgid.tls.msk.ru>
Date: Mon, 15 Jun 2009 18:41:42 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: PC speaker beeps in 2.6.30?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone know what happened with PC speaker in 2.6.30?
Basically, it does not work anymore here, with the
config which is very similar to the one used for
previous 2.6.29 kernel (where PC speaker worked).
At least I don't see any relevant differences and
the (seemengly) relevant symbols -- which are
INPUT_PCSPKR and PCSPKR_PLATFORM -- are both set
to 'y' for both 2.6.29 and 2.6.30.

Help? :)

Thanks.

/mjt
