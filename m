Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYFWVgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYFWVgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYFWVgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:36:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42917 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbYFWVgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:36:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] introduce PF_KTHREAD flag
Date: Mon, 23 Jun 2008 23:36:59 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, mingo@elte.hu,
       torvalds@linux-foundation.org, roland@redhat.com,
       linux-kernel@vger.kernel.org
References: <20080601153042.GA8238@tv-sign.ru> <20080623134706.f5e1ef32.akpm@linux-foundation.org> <20080623135253.ed7cabf1.akpm@linux-foundation.org>
In-Reply-To: <20080623135253.ed7cabf1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806232336.59965.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 23 of June 2008, Andrew Morton wrote:
> On Mon, 23 Jun 2008 13:47:06 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I don't yet know how much additional damage will happen as a result.
> 
> Lots.

Well, sorry about that.  I can ask Len to drop the freezer patch temporarily
and rebase it on top of -next if that helps.

