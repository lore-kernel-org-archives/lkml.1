Return-Path: <linux-kernel-owner+w=401wt.eu-S933858AbXHLLt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933858AbXHLLt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 07:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXHLLtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 07:49:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50372 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288AbXHLLtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 07:49:16 -0400
Date: Sun, 12 Aug 2007 13:49:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20070812114913.GA20669@one.firstfloor.org>
References: <p73zm0xslyk.fsf@bingen.suse.de> <515984.88226.qm@web36611.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515984.88226.qm@web36611.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Entries are never deleted, although they can be modified.

The modification case still seems racy then.

-Andi

