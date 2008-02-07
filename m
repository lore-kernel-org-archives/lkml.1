Return-Path: <linux-kernel-owner+w=401wt.eu-S933890AbYBGWop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbYBGWop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758253AbYBGWoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:44:37 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2574 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757344AbYBGWog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:44:36 -0500
Subject: Re: [patch 0/4] make pr_debug() dynamic
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mathieu.desnoyers@polymtl.ca, akpm@linux-foundation.org, mingo@elte.hu,
       fche@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080207210320.GA14732@redhat.com>
References: <20080207210320.GA14732@redhat.com>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 14:42:14 -0800
Message-Id: <1202424134.27394.42.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-07 at 16:03 -0500, Jason Baron wrote:
> make the pr_debug() function dependent upon the new immediate infrastruture.

What's wrong with klogd -c 8 or equivalent?


