Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbZBETCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbZBETCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbZBETCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:02:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52558 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbZBETCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:02:22 -0500
Date: Thu, 5 Feb 2009 17:04:37 -0200
From: Glauber Costa <glommer@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       avi@redhat.com, akataria@vmware.com
Subject: Re: [PATCH 0/2] expose hypervisor information on cpuid
Message-ID: <20090205190437.GA23273@poweredge.glommer>
References: <1233859341-10419-1-git-send-email-glommer@redhat.com> <20090205185207.GB27684@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205185207.GB27684@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 10:52:07AM -0800, Chris Wright wrote:
> * Glauber Costa (glommer@redhat.com) wrote:
> > This discussion happened some days ago in kvm list.
> > We believe it's useful to advertise hypervisor information
> > somewhere. /proc/cpuinfo appears as one good candidate.
> 
> What's wrong with /sys/hypervisor?  That's what it's there for.
> 
I believe cpuinfo provides a more standard interface for that.
But I'm not opposed to your suggestion.
