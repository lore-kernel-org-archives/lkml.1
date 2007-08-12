Return-Path: <linux-kernel-owner+w=401wt.eu-S936560AbXHLRel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936560AbXHLRel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762335AbXHLRed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:34:33 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:55864 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762AbXHLRec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:34:32 -0400
Message-ID: <46BF44A6.7010401@s5r6.in-berlin.de>
Date: Sun, 12 Aug 2007 19:34:30 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] Add some missing Documentation/*/00-INDEX files
References: <200708120045.03032.jesper.juhl@gmail.com>	 <46BF01A5.9060003@s5r6.in-berlin.de> <9a8748490708121010q7fe3bfbx8d4d8b997ed5fc72@mail.gmail.com>
In-Reply-To: <9a8748490708121010q7fe3bfbx8d4d8b997ed5fc72@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> On 12/08/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Isn't it with 00-INDEX just like with the "Last Updated:" footers in
>> documentation texts?
>>
> That is certainly a risk, yes. But it shouldn't be hard to write a
> small script to check if the 00-INDEX files are up-to-date, that will
> make it pretty simple to update them once in a while if people forget.

Or use the first line of each text file to describe what the file is about.

And BTW, if authors insist on "Last Updated:", make it a header rather
than a footer.  Increases the chance that submitters remember to update it.
-- 
Stefan Richter
-=====-=-=== =--- -==--
http://arcgraph.de/sr/
