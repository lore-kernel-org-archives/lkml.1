Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbXHBDjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbXHBDjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 23:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbXHBDjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 23:39:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41370 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbXHBDjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 23:39:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B151CE.4000204@s5r6.in-berlin.de>
Date: Thu, 02 Aug 2007 05:38:54 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Olaf Hering <olh@suse.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22: oops in sbp2_remove_device
References: <20070801175718.GA19589@suse.de> <tkrat.f4fe19cd6ad9843d@s5r6.in-berlin.de> <20070801231703.GA25672@suse.de>
In-Reply-To: <20070801231703.GA25672@suse.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering wrote:
> On Wed, Aug 01, Stefan Richter wrote:
>> Revert commit 0555659d63c285ceb7ead3115532e1b71b0f27a7 from 2.6.22-rc1.

> This change fixes the oops, and I can access the drive again.

Did it oops always or only sometimes?
-- 
Stefan Richter
-=====-=-=== =--- ---=-
http://arcgraph.de/sr/
