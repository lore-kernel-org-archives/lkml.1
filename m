Return-Path: <linux-kernel-owner+w=401wt.eu-S1161300AbYCSWCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161300AbYCSWCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932878AbYCSUXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:23:47 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:28798 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbYCSUXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:23:45 -0400
Message-ID: <1f1b08da0803191029w6878f693l6ac24f974a088676@mail.gmail.com>
Date: Wed, 19 Mar 2008 10:29:34 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: LinuxPPS (RESUBMIT 2): the PPS Linux implementation.
Cc: linux-kernel@vger.kernel.org, "David Woodhouse" <dwmw2@infradead.org>,
       "Dave Jones" <davej@redhat.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Greg KH" <greg@kroah.com>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Rodolfo Giometti" <giometti@linux.it>
In-Reply-To: <12048053463198-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12048053463198-git-send-email-giometti@linux.it>
X-Google-Sender-Auth: a44f30bdab3a2a96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2008 at 5:08 AM, Rodolfo Giometti <giometti@linux.it> wrote:
> This patch set adds the PPS support into Linux.
>
>  PPS means "pulse per second" and its API is specified by RFC 2783
>  (Pulse-Per-Second API for UNIX-like Operating Systems, Version 1.0).
>
>  The code has been tested with the NTPD program
>  (http://www.eecis.udel.edu/~mills/ntp/html/index.html) and several GPS
>  antennae.

Hey Andrew,
  Are there any remaining objections that are keeping you from picking
this patchset up?

thanks
-john
