Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbYAYQg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbYAYQg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYAYQgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:36:21 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:56930 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbYAYQgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:36:21 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <479A0FD7.5050003@s5r6.in-berlin.de>
Date: Fri, 25 Jan 2008 17:35:35 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] firewire: enforce access order between generation
 and node ID
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>	<200711011453.35268.nickpiggin@yahoo.com.au>	<4729A1BF.8010800@s5r6.in-berlin.de>	<tkrat.288da3bd61ecfb20@s5r6.in-berlin.de>	<tkrat.f1b275fda9e67a3c@s5r6.in-berlin.de> <4798B793.8080909@redhat.com>
In-Reply-To: <4798B793.8080909@redhat.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm going to commit it with a whitespace adjustment and a comment typo
fixed.  Jarod, thanks for the rigorous testing;  Nick, thanks for
helping in making this a solid improvement over the initial submission.
-- 
Stefan Richter
-=====-==--- ---= ==--=
http://arcgraph.de/sr/
