Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbYELPWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbYELPWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYELPWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:22:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36830 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYELPWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:22:30 -0400
Date: Mon, 12 May 2008 08:22:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 12
Message-Id: <20080512082205.8678bbaf.randy.dunlap@oracle.com>
In-Reply-To: <20080512150418.603e29cf.sfr@canb.auug.org.au>
References: <20080512150418.603e29cf.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008 15:04:18 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> News:  I am now providing patches relative to the latest tag in Linus'
> tree.  I propose to stop providing complete tar balls as they are so
> large and people will have recent versions of Linus's tree anyway (I
> assume).  The patches will be named "patch-<upstream tag>-<next tag>".

Oh well.  For the record, I don't mind using patches instead of
complete tarballs, but I would prefer that the patches be relative
to something like a daily -git snapshot so that using git is not
required at all.

---
~Randy
