Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYEMSqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYEMSqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 14:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYEMSqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 14:46:17 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:6021 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbYEMSqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 14:46:16 -0400
X-IronPort-AV: E=Sophos;i="4.27,480,1204531200"; 
   d="scan'208";a="46469615"
From: Roland Dreier <rdreier@cisco.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       John Gregor <john.gregor@qlogic.com>, general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][INFINIBAND]: Make ipath_portdata work with struct pid * not pid_t.
References: <482857AE.2030904@openvz.org>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 13 May 2008 11:46:13 -0700
In-Reply-To: <482857AE.2030904@openvz.org> (Pavel Emelyanov's message of "Mon,
	12 May 2008 18:43:58 +0400")
Message-ID: <ada4p92kpoq.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 May 2008 18:46:13.0770 (UTC) FILETIME=[9E8286A0:01C8B529]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
