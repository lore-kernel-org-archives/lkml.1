Return-Path: <linux-kernel-owner+w=401wt.eu-S933938AbZDHRsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938AbZDHRsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZDHRs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:48:27 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:29634 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZDHRs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:48:26 -0400
X-IronPort-AV: E=Sophos;i="4.39,345,1235952000"; 
   d="scan'208";a="282634850"
From: Roland Dreier <rdreier@cisco.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 17/56] infiniband: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 08 Apr 2009 10:48:22 -0700
In-Reply-To: <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm> (Jack
	Stone's message of "Wed, 8 Apr 2009 12:21:49 +0100")
Message-ID: <ada7i1v6nq1.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Apr 2009 17:48:22.0542 (UTC) FILETIME=[35D0AAE0:01C9B872]
Authentication-Results: syd-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/syddkim1002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will review and take via my tree... at first glance all look OK.

Thanks,
  Roland
