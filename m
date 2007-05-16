Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbXEPOav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbXEPOav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 10:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXEPOap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 10:30:45 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:60614 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbXEPOap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 10:30:45 -0400
Message-ID: <464B1594.3050407@s5r6.in-berlin.de>
Date: Wed, 16 May 2007 16:30:44 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: How to force Kconfig tristate into range n..m?
References: <20070515233002.GA9614@linux.vnet.ibm.com> <200705161418.49151.ak@suse.de>
In-Reply-To: <200705161418.49151.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> One way is to use a separate symbol that is not user visible, but depends
> on your main symbol and uses default m
> 
> (similar to the now infamous CONFIG_SCSI_WAIT_SCAN)

Actually CONFIG_SCSI_WAIT_SCAN should be visible and restricted to m or
n. :-)
-- 
Stefan Richter
-=====-=-=== -=-= =----
http://arcgraph.de/sr/
