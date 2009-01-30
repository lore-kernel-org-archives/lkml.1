Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbZA3Bvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbZA3Bvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZA3Bv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:51:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35304 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbZA3Bv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:51:26 -0500
Subject: Re: 2.6.28-rt on PowerPC
From: Steven Rostedt <srostedt@redhat.com>
To: frank.rowand@am.sony.com
Cc: avorontsov@ru.mvista.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-rt-users@vger.kernel.org
In-Reply-To: <49823A13.50703@am.sony.com>
References: <20090129213429.GA29014@oksana.dev.rtsoft.ru>
	 <1233270043.3833.57.camel@localhost.localdomain>
	 <49823A13.50703@am.sony.com>
Content-Type: text/plain
Organization: Red Hat
Date: Thu, 29 Jan 2009 20:51:09 -0500
Message-Id: <1233280269.3833.60.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-01-29 at 15:21 -0800, Frank Rowand wrote:
> Steven Rostedt wrote:

> Your email can at an opportune time for me...  I was starting to try
> 2.6.28-rt on ARM and quickly came to the conclusion that the arch
> patches weren't the focus yet.  But I'm currently side-tracked with
> getting my board to even boot a vanilla 2.6.28 kernel first.  Do
> you expect to get to the arches in the next week or two?  If not,
> I may head down that path for ARM myself.

I'm going to try to apply the arch patches, but I do not have an arm
board myself. I do have a PPC64 box that works, but that's about it. I
have a powerbook too, but that box has never been able to boot an -rt
kernel. Who knows, maybe this one will boot.

I will create an rt/arm and an rt/ppc branch for the specific changes on
each. I'll try to get them next week (maybe tomorrow if things go better
than planned).

-- Steve


