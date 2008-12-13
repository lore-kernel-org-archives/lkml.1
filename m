Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbYLMSt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbYLMSt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 13:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYLMStt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 13:49:49 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45570 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYLMStt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 13:49:49 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <494403C9.4070200@s5r6.in-berlin.de>
Date: Sat, 13 Dec 2008 19:49:45 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ieee1394: consolidate uses of IEEE1934_BUSID_MAGIC
References: <1229147871.11257.3.camel@brick>
In-Reply-To: <1229147871.11257.3.camel@brick>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Move the definition out of nodemgr.h and use it in csr.c/pcilynx.c

Committed to linux1394-2.6.git.
-- 
Stefan Richter
-=====-==--- ==-- -==-=
http://arcgraph.de/sr/
