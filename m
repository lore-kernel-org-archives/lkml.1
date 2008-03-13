Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbYCMGaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbYCMGaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYCMG3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:29:54 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:59773 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751116AbYCMG3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:29:53 -0400
Message-ID: <47D8C9E8.6020908@davidnewall.com>
Date: Thu, 13 Mar 2008 17:00:00 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: Chris Friesen <cfriesen@nortel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803121556.15547.phillips@phunq.net> <47D8BF76.8040105@davidnewall.com> <200803122317.24849.phillips@phunq.net>
In-Reply-To: <200803122317.24849.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
>> Your idea seems predicated on throwing large amounts of RAM at the
>> problem.  What I want to know is this: Is it really 25 times faster than
>> ext3 with an equally huge buffer cache?
>>     
>
> Yes.

Well, that sounds convincing.  Not.  You know this how?
