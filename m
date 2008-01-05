Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYAEThX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYAEThX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 14:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756495AbYAEThL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 14:37:11 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:37617 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbYAEThK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 14:37:10 -0500
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jan 2008 14:37:10 EST
Message-ID: <477FDAA8.2030001@hp.com>
Date: Sat, 05 Jan 2008 14:29:44 -0500
From: Mark Seger <Mark.Seger@hp.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Christoph Lameter <clameter@sgi.com>
Subject: Supports for new slab allocator now in latest release
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just wanted to let people know that as a result of a discussion on 
linux-mm I've added support for the new slab allocator to my collectl 
utility, now making it real easy to dynamically monitor allocations 
along with all the other types of monitoring collectl does.  I've also 
put together a webpage at http://collectl.sourceforge.net/SlabInfo.html 
to give a taste of how this all works as well as to show a few different 
types of output.
-mark

