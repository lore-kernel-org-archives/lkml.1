Return-Path: <linux-kernel-owner+w=401wt.eu-S1758387AbZEaKPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbZEaKPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 06:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbZEaKPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 06:15:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38773 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757891AbZEaKPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 06:15:21 -0400
Message-ID: <4A225881.7090909@redhat.com>
Date: Sun, 31 May 2009 13:14:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: chrisw@sous-sol.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v2 0/3] mmio/pio cleanup
References: <20090527213535.24324.62362.stgit@dev.haskins.net>
In-Reply-To: <20090527213535.24324.62362.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> This is v2 of the series, and applies to kvm.git/master:1a6a35a1)
>
> This is in prep for some more substantial mmio/pio work for iosignalfd,
> coming later.
>   

Looks good, will apply once Chris' comments are addressed.


-- 
error compiling committee.c: too many arguments to function

