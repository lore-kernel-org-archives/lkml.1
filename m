Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbYJaVC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYJaVC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 17:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYJaVCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 17:02:50 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:16509 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYJaVCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 17:02:49 -0400
X-IronPort-AV: E=Sophos;i="4.33,524,1220227200"; 
   d="scan'208";a="186522332"
From: Roland Dreier <rdreier@cisco.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: infiniband: struct device - replace bus_id with dev_name(), dev_set_name()
References: <1225329927.5970.80.camel@nga.site>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 31 Oct 2008 14:02:45 -0700
In-Reply-To: <1225329927.5970.80.camel@nga.site> (Kay Sievers's message of
	"Thu, 30 Oct 2008 02:25:27 +0100")
Message-ID: <adaljw4xytm.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Oct 2008 21:02:46.0019 (UTC) FILETIME=[061BC530:01C93B9C]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland Dreier <rolandd@cisco.com>
