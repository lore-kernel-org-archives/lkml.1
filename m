Return-Path: <linux-kernel-owner+w=401wt.eu-S1762530AbZBETx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762530AbZBETx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759459AbZBETxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:53:47 -0500
Received: from sous-sol.org ([216.99.217.87]:55188 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752948AbZBETxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:53:46 -0500
Date: Thu, 5 Feb 2009 10:52:07 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       avi@redhat.com, akataria@vmware.com
Subject: Re: [PATCH 0/2] expose hypervisor information on cpuid
Message-ID: <20090205185207.GB27684@sequoia.sous-sol.org>
References: <1233859341-10419-1-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233859341-10419-1-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Glauber Costa (glommer@redhat.com) wrote:
> This discussion happened some days ago in kvm list.
> We believe it's useful to advertise hypervisor information
> somewhere. /proc/cpuinfo appears as one good candidate.

What's wrong with /sys/hypervisor?  That's what it's there for.

thanks,
-chris
