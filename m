Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbXK3Jh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbXK3Jh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 04:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbXK3JhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 04:37:11 -0500
Received: from mx10.go2.pl ([193.17.41.74]:46486 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751029AbXK3JhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 04:37:09 -0500
Date: Fri, 30 Nov 2007 10:41:48 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Race between generic_forget_inode() and sync_sb_inodes()?
Message-ID: <20071130094148.GB2017@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18255.17747.484721.210728@notabene.brown>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-11-2007 00:03, Neil Brown wrote:
> On Friday November 30, dgc@sgi.com wrote:
...
>> Or have I just not had enough coffee this morning?
> 
> :-)  And I cannot even blame the lack of coffee as I don't drink it.
> 

Looks like logical error...

(Or I haven't had enough coffee this morning either?)

Regards,
Jarek P.
