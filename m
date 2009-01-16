Return-Path: <linux-kernel-owner+w=401wt.eu-S937660AbZAPVRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937660AbZAPVRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932909AbZAPVQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:16:49 -0500
Received: from gw.goop.org ([64.81.55.164]:49879 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937580AbZAPVQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:16:48 -0500
Message-ID: <4970F907.7030400@goop.org>
Date: Fri, 16 Jan 2009 13:15:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL}: latest tip/cpus4096 changes
References: <49704DF6.8040205@sgi.com> <20090116093442.GE4305@elte.hu> <4970BF1C.2020201@goop.org> <4970E614.5040607@sgi.com>
In-Reply-To: <4970E614.5040607@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
>
> Here tis... Christophe was kind enough to test it for me.  (I believe
> he said you were on vacation, though he did mention that you had some
> changes in the queue?)
>   

That looks OK, but it will clash with some of the pending patches.  I'll 
fix it up.

    J
