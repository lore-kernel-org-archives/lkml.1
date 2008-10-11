Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbYJKPeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbYJKPeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbYJKPeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:34:01 -0400
Received: from stinky.trash.net ([213.144.137.162]:52710 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbYJKPeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:34:00 -0400
Message-ID: <48F0C760.2050205@trash.net>
Date: Sat, 11 Oct 2008 17:33:52 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Grant Coady <gcoady.lk@gmail.com>
CC: Philip Stark <heller.barde@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27 seems to break something with DSL
References: <c6740f810810110553q75478033ub984651d5509199b@mail.gmail.com> <b6g1f4dkve11bscth3mon86fagchkqb76m@4ax.com>
In-Reply-To: <b6g1f4dkve11bscth3mon86fagchkqb76m@4ax.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Coady wrote:
> Well I connect via rp-pppoe to a bridged ADSL modem.  One recent gotcha 
> is that iptables userspace has to be updated to match the latest kernel, 
> how old is your distro?  What version iptables?  Last I checked 1.4.1.1 
> was latest available from netfilter.org.

No, old version should work fine, if not its a bug.
