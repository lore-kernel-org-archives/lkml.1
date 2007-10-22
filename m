Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbXJVRWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbXJVRWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXJVRWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:22:45 -0400
Received: from mga07.intel.com ([143.182.124.22]:33182 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751762AbXJVRWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:22:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,312,1188802800"; 
   d="scan'208";a="303417277"
Message-ID: <471CDC5E.4010300@linux.intel.com>
Date: Mon, 22 Oct 2007 13:22:38 -0400
From: Anas Nashif <nashif@linux.intel.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Marek Dabek <marek.dabek@intel.com>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Intel Manageability Engine Interface driver 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Manageability Engine Interface (aka HECI) allows applications to 
communicate with the Intel(R) Manageability Engine (ME) firmware.

It is meant to be used by user-space manageability applications to
access ME features such as Intel(R) Active Management Technology,
Intel(R) Quiet System Technology and ASF.

The patch is large so I'm placing the diff on the web for download
rather than attaching it here.  Download:

http://download.openamt.org/intel-MEI.diff


Anas
