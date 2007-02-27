Return-Path: <linux-kernel-owner+w=401wt.eu-S1161089AbXB0J15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161089AbXB0J15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 04:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161090AbXB0J15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 04:27:57 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47534 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161089AbXB0J1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 04:27:55 -0500
Message-ID: <45E3F99A.7050903@garzik.org>
Date: Tue, 27 Feb 2007 04:27:54 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: divy@chelsio.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 1/7] cxgb3 - manage sysfs attributes per port
References: <20070225004350.20795.71800.stgit@localhost.localdomain>
In-Reply-To: <20070225004350.20795.71800.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

divy@chelsio.com wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> sysfs attributes are now managed per port, no longer per adapter.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

applied 1-6 of 7


