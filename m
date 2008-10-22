Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbYJVRxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbYJVRxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760698AbYJVRvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:51:54 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:47640 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760695AbYJVRvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:51:53 -0400
Message-ID: <48FF67E1.4070001@nortel.com>
Date: Wed, 22 Oct 2008 11:50:25 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Hollis Blanchard <hollis@penguinppc.org>
CC: Paul Mackerras <paulus@samba.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: build failure on powerpc with current -git
References: <48F8E86B.702@nortel.com> <18685.27030.529655.761257@cargo.ozlabs.ibm.com> <20081021191324.d4810d40.sfr@canb.auug.org.au> <18686.42209.47915.184451@cargo.ozlabs.ibm.com> <fb412d760810220819o1a15d47ej198f6e15c3e63f15@mail.gmail.com>
In-Reply-To: <fb412d760810220819o1a15d47ej198f6e15c3e63f15@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2008 17:50:26.0994 (UTC) FILETIME=[AA988920:01C9346E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hollis Blanchard wrote:

> binutils 2.16.1 is the most recent binutils that will build with 
> crosstool, so IMHO it's worth supporting. :)

I was wondering about that....wasted a bunch of time trying to build something 
more recent.

Chris
