Return-Path: <linux-kernel-owner+w=401wt.eu-S1750959AbXA2TpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959AbXA2TpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbXA2TpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:45:24 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50468 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbXA2TpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:45:23 -0500
Message-ID: <45BE4ED0.5030808@us.ibm.com>
Date: Mon, 29 Jan 2007 13:45:20 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
Reply-To: maynardj@us.ibm.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net
Subject: [RFC, PATCH 0/4] Add support to OProfile for profiling Cell BE SPUs
  -- update
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On December 14, 2006, I posted a patch that added support to the 
OProfile kernel driver for profiling Cell SPUs.  There have been some 
changes/fixes to this patch since the original posting (including 
forward porting from 2.6.18-based kernel to 2.6.20-rc1), so I am 
reposting the patch for review now.  This patch relies upon the 
following patches that have not been accepted yet:
   1. oprofile cleanup patch (submitted on Nov 27)
   2. Fix for PPU profiling (not submitted yet, since it depends on #1)
   3. SPU task notification patch (last submitted on Jan 26)

For those who may want to apply and build the oprofile SPU support 
patch, it would be necessary to first apply the above patches.  For 
convenience, I will post all three of the above patches, along with the 
oprofile SPU support patch.

Comments appreciated.

Thank you.

Maynard Johnson
IBM LTC Toolchain

