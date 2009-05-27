Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbZE0RAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbZE0RAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZE0RAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:00:10 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:40403 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbZE0RAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:00:09 -0400
Message-ID: <4A1D7193.1040600@nortel.com>
Date: Wed, 27 May 2009 11:00:03 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: Re: linux missing support for _POSIX_THREAD_CPUTIME ?
References: <4A1D6E71.90602@nortel.com>
In-Reply-To: <4A1D6E71.90602@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2009 17:00:07.0788 (UTC) FILETIME=[96A602C0:01C9DEEC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:

> It appears that linux doesn't support this functionality--is that
> correct?  Is there any plan to enable this?

In particular, it seems to fail the invalid_clockid() test.  Is that
function expecting the clock ID to be negative for this case?

Thanks,

Chris
