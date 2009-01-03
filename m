Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbZACQvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbZACQvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 11:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZACQvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 11:51:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34341 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZACQvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 11:51:13 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <495F976C.8030105@s5r6.in-berlin.de>
Date: Sat, 03 Jan 2009 17:50:52 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Bill Fink <billfink@mindspring.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 2/2] ieee1934: dv1394 interrupt enabling/disabling broken
 on big-endian
References: <1229210489.11257.16.camel@brick>	<4944561D.4010608@s5r6.in-berlin.de>	<20081213204137.d150645c.billfink@mindspring.com>	<49446923.5040606@s5r6.in-berlin.de>	<20081223172300.5bd19846.billfink@mindspring.com> <20081225220244.1eacb39d.billfink@mindspring.com>
In-Reply-To: <20081225220244.1eacb39d.billfink@mindspring.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Fink wrote on 2008-12-26:
> Good news.  I finally got a chance to test the patch on my kernel,
> and live DV viewing using xine still worked fine.

Thanks a lot.  If you don't mind, I'll add "Tested-by: Bill Fink
<billfink@mindspring.com>" to the changelog when I enqueue this for
Linus, and add a note that it actually worked for you before as well as
after this patch.
-- 
Stefan Richter
-=====-==--= ---= ---==
http://arcgraph.de/sr/
