Return-Path: <linux-kernel-owner+w=401wt.eu-S934641AbXHLMtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641AbXHLMtF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 08:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762517AbXHLMsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 08:48:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39762 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761740AbXHLMsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 08:48:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46BF01A5.9060003@s5r6.in-berlin.de>
Date: Sun, 12 Aug 2007 14:48:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] Add some missing Documentation/*/00-INDEX files
References: <200708120045.03032.jesper.juhl@gmail.com>
In-Reply-To: <200708120045.03032.jesper.juhl@gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> Rob Landley is trying to organize Linux kernel documentation. One 
> thing he is doing is generating index.html files based on our 
> 00-INDEX files in the Documentation directory. He has met with a 
> small problem however, since not all subdirectories inside 
> Documentation contain such a file, nor are all the files that do 
> exist up to date, his index.html files turn up rather incomplete.
[...]
> I want to get some feedback before wasting too much time 
> creating these files
[...]

Isn't it with 00-INDEX just like with the "Last Updated:" footers in
documentation texts?

They are metadata which will be almost always out of date.
-- 
Stefan Richter
-=====-=-=== =--- -==--
http://arcgraph.de/sr/
