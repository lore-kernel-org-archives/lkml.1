Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbYABU34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbYABU34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbYABU3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:29:47 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:46729 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753530AbYABU3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:29:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fA85KSFnvLb8vo6dnhHV65bEhb8xy+gAF0MJEoZCid9cqshk/pnnEDqtJ7B57unAJBNP6K2J4MYtNil1XX8oMJUOngW3ylo2mNtRRZjtj548Txzm5kRsiji5Cb+RuHzNc8GMCuywc4mj2lihU8yxB5YH+o5pa/JGtylKLHnzFCE=  ;
X-YMail-OSG: 8FgYW2AVM1m6PpnCg_r2hNnIHJmtYglFd9b0jg0rOWq8_wJscqVxgkQP3.6SheZYu0BdZWDUNw--
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended (rev. 2)
Date: Wed, 2 Jan 2008 12:29:42 -0800
User-Agent: KMail/1.9.6
Cc: kay.sievers@vrfy.org, a.zummo@towertech.it, stern@rowland.harvard.edu,
       rjw@sisk.pl, pavel@suse.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       lenb@kernel.org, gregkh@suse.de, akpm@linux-foundation.org
References: <200801020032.45529.rjw@sisk.pl> <20080102175400.3C2E0EF588@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20080102201451.GC3985@elte.hu>
In-Reply-To: <20080102201451.GC3985@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021229.43555.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2008, Ingo Molnar wrote:
> 
> then please provide a kernel config option for the new driver to take 
> over 10:135 too. There's nothing worse to the adoption of new kernel 
> features necessiating user-space attention. I've got several images of 
> old distros that i dont want to reconfigure in any way, and it would be 
> nice to have a drop-in /dev/rtc replacement for them. Really. This is 
> how we do it for just about everything else too.

I'll let someone else chase that particular issue.  :)

