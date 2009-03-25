Return-Path: <linux-kernel-owner+w=401wt.eu-S1763902AbZCYTCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763902AbZCYTCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbZCYTCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:02:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbZCYTC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:02:29 -0400
Date: Wed, 25 Mar 2009 15:02:24 -0400
From: Bill Nottingham <notting@redhat.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Declare PIO_CMAP/GIO_CMAP as compatbile ioctls.
Message-ID: <20090325190224.GA25176@nostromo.devel.redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <1238007647-25752-1-git-send-email-notting@redhat.com> <1238007647-25752-2-git-send-email-notting@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238007647-25752-2-git-send-email-notting@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Nottingham (notting@redhat.com) said: 
> Otherwise, these don't work when called from 32-bit userspace on 64-bit kernels.

Sorry about this last bit - git hiccup.

Bill
