Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbZEVVqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbZEVVqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbZEVVqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:46:06 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:58019 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952AbZEVVqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:46:06 -0400
X-Greylist: delayed 791 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 May 2009 17:46:05 EDT
Message-ID: <4A171CF7.9020609@unsolicited.net>
Date: Fri, 22 May 2009 22:45:27 +0100
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
 down
References: <4A1719DE.4060009@unsolicited.net>
In-Reply-To: <4A1719DE.4060009@unsolicited.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> ..that was introduced in 2.6.27. Reverting this change in 2.6.29-rc5
> makes the card work happily again.
>   
Make that 2.6.30-rc5 .. my brain is obviously fried from too much .NET
this week :-(

