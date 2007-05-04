Return-Path: <linux-kernel-owner+w=401wt.eu-S1767656AbXEDDvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767656AbXEDDvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 23:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767660AbXEDDvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 23:51:40 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:30481 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767656AbXEDDvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 23:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NjbJVab738N5WR+dM0RNSlDknDX0WzHMsNJZqvuoaCut0nrHYi0ahCNJfsvUm60TXuYllD6I1ZBqxnIhKvQbq74RDaab2yZK44DNkyWEOgeFpXZJrYs69SNiRJIKzEA/vcxRgMyedkODX0yDidQHj8E82VinEgMTdNxH0GsZKac=
Message-ID: <af3ea28a0705032051q61417b81nad47d5dbd6aec272@mail.gmail.com>
Date: Fri, 4 May 2007 11:51:38 +0800
From: "ye janboe" <janboe.ye@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: how can I debug to debug kernel pointer error?
In-Reply-To: <af3ea28a0705032050t1cd856acu7422fe60951b6bd1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <af3ea28a0705030742v4ba07a65sabe5dc9dc24ffe1c@mail.gmail.com>
	 <af3ea28a0705032050t1cd856acu7422fe60951b6bd1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
I met a issue that some code changing one process preempt_count.
preempt_count is changed to a very large number, for instant, 0x300,
just before finish_schedule function in schedule.

Who can give me some suggestion to debug such problem?

Thanks very much!

Janboe
