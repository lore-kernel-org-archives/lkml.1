Return-Path: <linux-kernel-owner+w=401wt.eu-S1751349AbXBPHAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbXBPHAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXBPHAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:00:35 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55103 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbXBPHAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:00:34 -0500
Date: Thu, 15 Feb 2007 22:59:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 00/21] Xen-paravirt: Xen guest implementation for
 paravirt_ops interface
Message-Id: <20070215225932.11a1b43e.akpm@linux-foundation.org>
In-Reply-To: <20070216022449.739760547@goop.org>
References: <20070216022449.739760547@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 18:24:49 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> This patch series implements the Linux Xen guest in terms of the
> paravirt-ops interface.

The whole patchset exports 67 symbols to modules.  How come?

Are they all needed?
