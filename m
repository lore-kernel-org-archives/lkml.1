Return-Path: <linux-kernel-owner+w=401wt.eu-S1762158AbXFDT0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762158AbXFDT0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761396AbXFDT0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:26:33 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:14386 "EHLO
	mail49-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbXFDT0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:26:32 -0400
X-Greylist: delayed 1082 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2007 15:26:32 EDT
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <46646389.7090101@am.sony.com>
Date: Mon, 04 Jun 2007 12:10:01 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: Problem with http URL for stable git tree?
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2007 19:08:25.0972 (UTC) FILETIME=[BA766B40:01C7A6DB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I'm having problems cloning the stable git tree for 2.6.21.
Here's what I get:

$ git clone http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git stable-2.6.21.y
Cannot get remote repository information.
Perhaps git-update-server-info needs to be run there?

------
I believe I cloned this tree a few weeks ago successfully.
Did something break?

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

