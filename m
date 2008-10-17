Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbYJQXdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbYJQXdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbYJQXdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:33:08 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47538 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbYJQXdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:33:06 -0400
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrey Mirkin <major@openvz.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <1220439476-16465-1-git-send-email-major@openvz.org>
References: <1220439476-16465-1-git-send-email-major@openvz.org>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 16:33:03 -0700
Message-Id: <1224286383.1848.65.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-03 at 14:57 +0400, Andrey Mirkin wrote:
> This patchset introduces kernel based checkpointing/restart as it is
> implemented in OpenVZ project. This patchset has limited functionality and
> are able to checkpoint/restart only single process. Recently Oren Laaden
> sent another kernel based implementation of checkpoint/restart. The main
> differences between this patchset and Oren's patchset are:

Hi Andrey,

I'm curious what you want to happen with this patch set.  Is there
something specific in Oren's set that deficient which you need
implemented?  Are there some technical reasons you prefer this code?

-- Dave

