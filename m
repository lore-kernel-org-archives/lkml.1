Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbYHZLF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbYHZLF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYHZLFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:05:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45462 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbYHZLFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:05:51 -0400
Date: Tue, 26 Aug 2008 13:08:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, jassi_singh_brar@yahoo.com,
       linux-kernel@vger.kernel.org
Subject: Re: An idea .... with code
Message-ID: <20080826110815.GK26610@one.firstfloor.org>
References: <801995.65435.qm@web33201.mail.mud.yahoo.com> <87tzd89oap.fsf@basil.nowhere.org> <20080826104454.GA13455@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826104454.GA13455@x200.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > For me it seems more that most of the file system based command
> > interfaces (/proc/mtrr comes to mind) are quite hard to use
> 
> Name four.

What do you mean?

> 
> > and I prefer a proper command line tool with a manpage and --help
> > and a real parser any day.
> 
> Go write mtrrctl(1) and a manpage. You'll need it in case of
> ioctl-based interface anyway.

That's actually a good idea. 

-Andi
