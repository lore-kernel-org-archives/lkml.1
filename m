Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZJYAI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZJYAI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 20:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZJYAI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 20:08:27 -0400
Received: from smtpout12.uol.com.br ([200.221.4.203]:56632 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751997AbZJYAI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 20:08:26 -0400
Date: Sat, 24 Oct 2009 22:08:20 -0200
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: bugzilla-daemon@bugzilla.kernel.org
Cc: Denys Rogovchenko <denisius.sion@gmail.com>,
       "Rafael J.Wysocki" <rjw@sisk.pl>,
       "Artem S.Tashkinov" <t.artem@mailcity.com>,
       ykzhao <yakui.zhao@intel.com>, len.brown@intel.com, gmaizel@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug 11255] S3: no resume, not even a beep - LG R700
Message-ID: <20091025000820.GA16225@ime.usp.br>
References: <bug-11255-5003@http.bugzilla.kernel.org/>
 <200909291835.n8TIZigc018246@demeter.kernel.org>
 <8BDFD7B4-ABB5-45BD-BBC9-21C6AC4F48E9@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8BDFD7B4-ABB5-45BD-BBC9-21C6AC4F48E9@ime.usp.br>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SIG5: 919aea4ff3668a63be180cde8ec381a5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, people.

First of all, to the bug reporters: please, let's get a bit more closer
and try to join our forces.

Triaging the bug report, seeing what still happens with the current
kernels etc. would all be helpful if we want to get our notebooks
working.

OK, now to the problem itself.

After some time without internet connection (humpf), I am back online
and I just did a git pull and a new kernel is being baked, soon to be
served. :-)

I did collect quite a bunch of extra information (including newer blobs
of dsdt, after the firmware upgrade from the firmware from MSI) and I
will upload those in a moment.

I hope that this will help us to better decide what is the culprit and
how we can better address this problem (perhaps asking MSI for some
involvement?).

Anyway, just as an extra piece of information, my notebook is what MSI
calls an MSI Aesthetic PR200 (well, at least after flashing it, that's
what it reports :) and it didn't die with this upgrade).

Some extra pointers (a script, actually) of what I did to create a boot
USB "disk" are outlined here: http://rb.doesntexist.org/diary/2009.xhtml


Hope this helps so far, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
