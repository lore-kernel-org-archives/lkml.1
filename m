Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbXDNXq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbXDNXq6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 19:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXDNXq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 19:46:58 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:15620 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbXDNXq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 19:46:57 -0400
Message-ID: <5640c7e00704141646k44334de9g99dc509bf96bac5f@mail.gmail.com>
Date: Sun, 15 Apr 2007 11:46:56 +1200
From: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: {Spam?} [PATCH] NET: Remove obsolete traffic shaper code.
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704141925310.22138@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704141925310.22138@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/15/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>
> Remove the obsolete code for the traffic shaper.
>
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>
Apart from the merits of removing this which I can't comment on, I
thought the usual procedure was to place a removal in
Documentation/feature-removal-schedule.txt to notify people of what is
going to be removed. Then wait the period you determine there and then
remove.

Ian
-- 
Web: http://wand.net.nz/~iam4/
Blog: http://iansblog.jandi.co.nz
WAND Network Research Group
