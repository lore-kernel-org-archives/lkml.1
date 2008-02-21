Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYBUTh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYBUTh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761631AbYBUThb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:37:31 -0500
Received: from gw.goop.org ([64.81.55.164]:46703 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760852AbYBUTh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:37:27 -0500
Message-ID: <47BDD267.9010706@goop.org>
Date: Thu, 21 Feb 2008 11:35:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: yamahata@valinux.co.jp
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, linux-ia64@vger.kernel.org,
       xen-ia64-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       "Stephen C. Tweedie" <sct@redhat.com>
Subject: Re: [PATCH 00/11] Xen arch portability patches
References: <20080221084530.470680000@ls.local.valinux.co.jp>
In-Reply-To: <20080221084530.470680000@ls.local.valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yamahata@valinux.co.jp wrote:
> Hi. Recently the xen-ia64 community started to make efforts to merge 
> xen/ia64 Linux to upstream. The first step is to merge up domU portion.
> This patchset is preliminary for xen/ia64 domU linux making the current
> xen/x86 domU code more arch generic and adding missing definitions and
> files.
>   

I haven't looked at the whole series yet, but this seems fine in 
principle.  One thing: using attachments to post makes it hard to do 
inline comments on the patches.

    J
