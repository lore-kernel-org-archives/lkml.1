Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbYBKQyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbYBKQyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYBKQyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:54:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbYBKQx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:53:59 -0500
Message-ID: <47B07D8B.10905@redhat.com>
Date: Mon, 11 Feb 2008 11:53:31 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] firewire: log GUID of new devices
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.4304cda1ec1be99d@s5r6.in-berlin.de>
In-Reply-To: <tkrat.4304cda1ec1be99d@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> This should help to interpret user reports.  E.g. one can look up the
> vendor OUI (first three bytes of the GUID) and thus tell what is what.
> 
> Also simplifies the math in the GUID sysfs attribute.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Rather liking this one, makes it much easier to figure out what's what 
without having to poke around in config roms.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
