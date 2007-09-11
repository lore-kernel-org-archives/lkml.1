Return-Path: <linux-kernel-owner+w=401wt.eu-S1764750AbXIKTM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764750AbXIKTM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933890AbXIKTI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:08:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33887 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933845AbXIKTIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:08:54 -0400
Date: Tue, 11 Sep 2007 21:08:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Nicolas Pitre <nico@cam.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       jgarzik <jgarzik@pobox.com>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
In-Reply-To: <alpine.LFD.0.9999.0709111333050.21186@xanadu.home>
Message-ID: <Pine.LNX.4.64.0709112105520.9962@fbirervta.pbzchgretzou.qr>
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com>
 <alpine.LFD.0.9999.0709111333050.21186@xanadu.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 11 2007 14:03, Nicolas Pitre wrote:
>> +Alpine (TUI)
>> +
>> +<I don't know.  Maybe Adrian or Linus can comment.>
>> +
>> +Are any special config options needed?
>
>Alpine is the successor of Pine.  Issues that were found in some earlier 
>Pine versions wrt patch sending are now fixed.
>
>Here's the relevant config options. In the "Sending Preferences" 
>section:
>
> - "Do Not Send Flowed Text" must be enabled

I have quell-flowed-text *disabled* and there is no problem.


	Jan

test:

--- /dev/fd/63	2007-09-11 21:08:05.555626230 +0200
+++ /dev/fd/62	2007-09-11 21:08:05.555626230 +0200
@@ -1,3 +1,3 @@
-total 52
--rw-r--r-- 1 jengelh users 52765 Sep 10 20:42 random.png 
 -rw-r--r-- 1 jengelh users     0 Sep 11 21:07 pat
+-rw-r--r-- 1 jengelh users 52765 Sep 10 20:42 random.png
+total 52
