Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbZADX3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbZADX3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZADX3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:29:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48579 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZADX3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:29:13 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49614639.5090901@s5r6.in-berlin.de>
Date: Mon, 05 Jan 2009 00:28:57 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] firewire: cdev: proposed ABI extensions
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
In-Reply-To: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> These patches apply after several as yet uncommitted firewire patches,

I committed the prerequisites to linux1394-2.6.git now, branch: cdev.
I also committed all the new patches to branch: test, for those who'd
rather look through git or gitweb at the patches.

The linux1394-2.6.git branches misc, cdev, topology, for-next, and
master have been rebased onto v2.6.28.
-- 
Stefan Richter
-=====-==--= ---= --=-=
http://arcgraph.de/sr/
