Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbZBYOpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbZBYOpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZBYOo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:44:59 -0500
Received: from mail.suse.de ([195.135.220.2]:49951 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbZBYOo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:44:58 -0500
Message-ID: <49A55966.6000702@suse.de>
Date: Wed, 25 Feb 2009 15:44:54 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Frank Seidel <frank@f-seidel.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       akpm@linux-foundation.org, hannes@hanneseder.net,
       johannes@sipsolutions.net, "David S. Miller" <davem@davemloft.net>,
       wangchen@cn.fujitsu.com, "John W. Linville" <linville@tuxdriver.com>,
       Frank Seidel <fseidel@suse.de>
Subject: Re: [PATCH][trivial] airo: reduce stack memory footpring
References: <49A5583D.5050502@f-seidel.de>
In-Reply-To: <49A5583D.5050502@f-seidel.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, $SUBJECT should of course be:
[PATCH][trivial] airo: reduce stack memory footprint
