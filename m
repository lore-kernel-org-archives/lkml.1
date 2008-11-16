Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYKPSCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYKPSCt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYKPSCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:02:39 -0500
Received: from lazybastard.de ([212.112.238.170]:39100 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYKPSCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:02:39 -0500
Date: Sun, 16 Nov 2008 19:02:25 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: unify mtd partition/device registration
Message-ID: <20081116180224.GB703@logfs.org>
References: <1226533133-7405-1-git-send-email-vapier@gentoo.org> <20081116173453.GA703@logfs.org> <200811161255.18513.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200811161255.18513.vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 November 2008 12:55:17 -0500, Mike Frysinger wrote:
> 
> maybe i'll stick a comment above it ... the reason was to be proactive in 
> preventing mtd partitioning code bleeding into the core.  maybe i'm just 
> paranoid.

Sounds a bit silly to me. *shrugs*

Jörn

-- 
It is the mark of an educated mind to be able to entertain a thought
without accepting it.
-- Aristotle
