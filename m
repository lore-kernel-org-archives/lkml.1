Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbYAHQJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbYAHQJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760056AbYAHQJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:09:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51098 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759488AbYAHQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:09:05 -0500
Date: Tue, 8 Jan 2008 17:11:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Andi Kleen <andi@firstfloor.org>, Bernd Schubert <bernd-schubert@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: sleep before boot panic
Message-ID: <20080108161130.GA31504@one.firstfloor.org>
References: <200801061908.43010.bernd-schubert@gmx.de> <p731w8ts70k.fsf@bingen.suse.de> <200801080717.03467.ioe-lkml@rameria.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801080717.03467.ioe-lkml@rameria.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I really like the "soft" panic better, where you still can operate the 
> kernel debugging features, but just have no user space supporting it.

There is no specific reason many kernel debugging features (sysrq, scrollback) 
cannot work in the hard panic -- except that nobody coded it yet.

-Andi
