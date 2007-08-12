Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbXHLBIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbXHLBIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 21:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbXHLBIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 21:08:06 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:49310 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbXHLBIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 21:08:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=uWY3LD8vnsCSiy9UkEqgxqQuzZXRUWeqZP36K0AtJ3LVWLSt9vzi1YetBm595AbbVbogffxEnDT9R6zRBtJo7ax6a8pu2FtSuecvvo1dkiglKUfHSCqNsaBUuKjIWMFBybst5peE101d7VC0TgvcnZmu8OFIdFsqJboOLeENcXw=
Message-ID: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com>
Date: Sun, 12 Aug 2007 03:08:03 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Are we properly prepared to handle 3 Socket setups?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This may be a little off topic, but I think it's interresting enough
to warrent a single mail.

I just saw a news article (http://www.theinquirer.net/?article=41610)
about a 3 Socket Opteron motherboard and couldn't help but wonder if
we are prepared to deal with such a beast, so I thought I'd inform
everyone :-)

I'm guessing equipping such a board with 3 single core CPU's could
show up some interresting corner cases in schedular code and
elsewhere, I'll bet we have some assumptions somewhere about
nr_of_cpus being an even number... In any case it would be an
interresting box to test on, so for those of you employed by big
business with the cash to purchase a test box, it would at least be an
interresting one to add to the mix :)

Anyway, just wanted to give everyone a heads-up, bye bye...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
