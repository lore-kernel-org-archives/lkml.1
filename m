Return-Path: <linux-kernel-owner+w=401wt.eu-S1759722AbYECKNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbYECKNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbYECKNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:13:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54848 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbYECKNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:13:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <481C3AA2.6020809@s5r6.in-berlin.de>
Date: Sat, 03 May 2008 12:12:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: charter for -next
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What should I ask myself before I commit something to the branch which 
Stephen pulls into -next?

     Is this ready to be pulled by Linus right now if he had a merge
     window open today?
or
     Is it likely that I will let Linus pull this when he opens his next
     merge window?  (Assuming I can roughly predict when this will be,
     and what other work will likely be done until then, e.g. pending
     reviewer feedback, or patches for related functionality which should
     be bundled with the work in question...)
-- 
Stefan Richter
-=====-==--- -=-= ---==
http://arcgraph.de/sr/
