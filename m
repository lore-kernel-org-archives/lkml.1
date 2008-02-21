Return-Path: <linux-kernel-owner+w=401wt.eu-S1761835AbYBUTmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835AbYBUTmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYBUTmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:42:21 -0500
Received: from gw.goop.org ([64.81.55.164]:53078 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbYBUTmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:42:20 -0500
Message-ID: <47BDD393.5080307@goop.org>
Date: Thu, 21 Feb 2008 11:40:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: yamahata@valinux.co.jp
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, linux-ia64@vger.kernel.org,
       xen-ia64-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       "Stephen C. Tweedie" <sct@redhat.com>
Subject: Re: [PATCH 03/11] xen: add missing definitions for xen grant table
 which ia64/xen needs.
References: <20080221084530.470680000@ls.local.valinux.co.jp> <20080221091001.314830000@ls.local.valinux.co.jp>
In-Reply-To: <20080221091001.314830000@ls.local.valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yamahata@valinux.co.jp wrote:

Yep.  We removed the guest handle stuff for the initial upstreaming, 
since it isn't necessary on x86 and it quietened some of the reviewer 
noise.  But I expected we'd need to reintroduce it at some stage.

    J
