Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbXFIJU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbXFIJU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 05:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXFIJUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 05:20:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:32854 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXFIJUR (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 05:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RNCgr8IhPre52WJpgPtuU3snfETDC8/wfqzMdMf7dw1oyRfjzS5Ys7JMx1IHt/v7pU7OKVfCu7VF92V4tnBvbSpb2CVur1gF9bVOLj6HIx9PJtxNIbExDDzMNbM6563FixPduYyHnxzhlpSTWGaqtBqxJj0Rc4fAwCl+Ids0NwY=
Message-ID: <466A70CE.6070409@gmail.com>
Date: Sat, 09 Jun 2007 11:20:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: CIJOML <cijoml@volny.cz>
CC: Linux-kernel@vger.kernel.org
Subject: Re: BUG: soft lockup detected on CPU#0! 2.6.21.3
References: <200706091029.37296.cijoml@volny.cz>
In-Reply-To: <200706091029.37296.cijoml@volny.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CIJOML napsal(a):
> Hi all,
> 
> please take care about following bug commited at bugzilla:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8603
> 
> Thanks a lot!

Does this happen without atheros drivers? Do you use hal or openhal?

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
