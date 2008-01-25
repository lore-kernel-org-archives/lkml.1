Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbYAYRWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbYAYRWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbYAYRWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:22:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58818 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbYAYRWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:22:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <479A1AB1.9010408@s5r6.in-berlin.de>
Date: Fri, 25 Jan 2008 18:21:53 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 update] firewire: fw-core: react on bus resets while
 the config ROM is being fetched
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>	<4798E664.2040405@redhat.com>	<tkrat.34be174a07a7f85e@s5r6.in-berlin.de> <200801251216.35291.jwilson@redhat.com>
In-Reply-To: <200801251216.35291.jwilson@redhat.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> On Friday 25 January 2008 11:53:49 am Stefan Richter wrote:
>> Update:  Barrier stays.
> 
> This is essentially what I've been beating on locally, and I've yet to hit 
> another config rom read failure with it.
> 
> Signed-off-by: Jarod Wilson <jwilson@redhat.com>

Thanks.  I already pushed to linux1394-2.6.git but I will add your
sign-off before I ask Linus to pull.
-- 
Stefan Richter
-=====-==--- ---= ==--=
http://arcgraph.de/sr/
