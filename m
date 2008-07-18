Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbYGRXNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbYGRXNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760947AbYGRXNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:13:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:3175 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760923AbYGRXNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:13:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,212,1215414000"; 
   d="scan'208";a="22186333"
Message-Id: <20080718230812.826863000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jul 2008 16:08:12 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [RFC patch 0/2] x86: Add debugfs entry for PAT memtype list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patchset adds a new entry for dumping PAT memtype list under debugfs.
I am adding a high level arch directory in debugfs to combine any other
such debug info. Not sure whether this is the 'right' approach or there
is anything else being planned for this. Hence the tag RFC.

-- 

