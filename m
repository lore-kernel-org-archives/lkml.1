Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYDQV6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYDQV6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 17:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbYDQV6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 17:58:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753AbYDQV6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 17:58:03 -0400
Date: Thu, 17 Apr 2008 14:57:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, xemul@openvz.org, ebiederm@xmission.com,
       manfred@colorfullife.com, mtk.manpages@googlemail.com,
       Nadia.Derbey@bull.net
Subject: Re: [PATCH 1/3] ipc: sysvsem: implement sys_unshare(CLONE_SYSVSEM)
Message-Id: <20080417145710.875927b9.akpm@linux-foundation.org>
In-Reply-To: <20080416164232.GB22748@sergelap.austin.ibm.com>
References: <20080416164232.GB22748@sergelap.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 11:42:32 -0500
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> (patches 1 and 2 were originally by Manfred Spraul)

The way we handle this is to put a From: line right at the start of the
changelog.

I've assumed that this is what you intended, and have made that change. 
But maybe you didn't intend to do this - perhaps the patches are
sufficiently different from Manfred's originals that this wasn't
appropriate?  It's appropriate for #2, maybe not #1.  I'll let you two
fight it out ;)


