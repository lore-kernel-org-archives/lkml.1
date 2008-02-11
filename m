Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYBKRD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYBKRD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYBKRDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:03:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYBKRDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:03:51 -0500
Message-ID: <47B07FDD.8030507@redhat.com>
Date: Mon, 11 Feb 2008 12:03:25 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] ieee1394: sbp2: add INQUIRY delay workaround
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.671012af0e073ed0@s5r6.in-berlin.de>
In-Reply-To: <tkrat.671012af0e073ed0@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Add the same workaround as found in fw-sbp2 for feature parity and
> compatibility of the workarounds module parameter.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Same deal as 2/9.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
