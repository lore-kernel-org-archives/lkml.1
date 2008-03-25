Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbYCYQJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbYCYQJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbYCYQI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:08:57 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:59856 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbYCYQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:08:56 -0400
Message-ID: <47E92396.6070203@tiscali.nl>
Date: Tue, 25 Mar 2008 17:08:54 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: yi.zhu@intel.com, reinette.chatre@intel.com
CC: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] wireless: convert !X & Y to !(X & Y) in iwl4965_is_fat_tx_allowed()
References: <47E92235.80500@tiscali.nl>
In-Reply-To: <47E92235.80500@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the triple mail, it appeared to fail twice.
