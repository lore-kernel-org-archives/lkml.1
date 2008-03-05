Return-Path: <linux-kernel-owner+w=401wt.eu-S1763019AbYCEWQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763019AbYCEWQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbYCEWQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:16:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756160AbYCEWQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:16:05 -0500
Date: Wed, 5 Mar 2008 14:15:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, systemtap@sourceware.org
Subject: Re: [PATCH 0/3] A kernel tracing interface (updated)
Message-Id: <20080305141505.bb9a002c.akpm@linux-foundation.org>
In-Reply-To: <1204588300.32186.6.camel@lc4eb748232119.ibm.com>
References: <1204588300.32186.6.camel@lc4eb748232119.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Mar 2008 15:51:39 -0800
"David J. Wilder" <dwilder@us.ibm.com> wrote:

> These patches provide a kernel tracing interface called "trace".

So I merged this.  Before proceeding further I think we should demonstrate
in some way that it will be useful: that developers will use it and get
useful results.  This will not be easy.
