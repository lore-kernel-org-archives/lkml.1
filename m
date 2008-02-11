Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbYBKRRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbYBKRRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYBKRRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:17:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYBKRRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:17:08 -0500
Message-ID: <47B082F9.6020306@redhat.com>
Date: Mon, 11 Feb 2008 12:16:41 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] firewire: fw-sbp2: log bus_id at management request
 failures
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.4fc5a11f66e8358c@s5r6.in-berlin.de>
In-Reply-To: <tkrat.4fc5a11f66e8358c@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> for easier readable logs if more than one SBP-2 device is present.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Agree this makes for easier to follow logs, esp. with lots of devices 
(not just spb2).

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
