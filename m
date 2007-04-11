Return-Path: <linux-kernel-owner+w=401wt.eu-S1160997AbXDKUqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160997AbXDKUqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1160998AbXDKUqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:46:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57286 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160997AbXDKUqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:46:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <461D48EE.2090304@s5r6.in-berlin.de>
Date: Wed, 11 Apr 2007 22:45:34 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
CC: kernel-janitors@lists.osdl.org, linux1394-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bcollins@debian.org
Subject: Re: [KJ][PATCH]SPIN_LOCK_UNLOCKED cleanup in
References: <20070411175434.GA9110@arun.site>
In-Reply-To: <20070411175434.GA9110@arun.site>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Milind Arun Choudhary wrote:
> SPIN_LOCK_UNLOCKED cleanup,use DEFINE_SPINLOCK instead 

Committed to linux1394-2.6.git. Thanks,
-- 
Stefan Richter
-=====-=-=== -=-- -=-==
http://arcgraph.de/sr/
