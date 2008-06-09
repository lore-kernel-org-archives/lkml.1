Return-Path: <linux-kernel-owner+w=401wt.eu-S1761143AbYFIO1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761143AbYFIO1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYFIO1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:27:14 -0400
Received: from mail.bluehost.com ([74.220.195.75]:59531 "HELO
	officemail.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751765AbYFIO1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:27:13 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 10:27:13 EDT
Subject: Re: [PATCH 2.6.25-4] getdelays.c: signal handling for log rotation
From: Scott Wiersdorf <scott@bluehost.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, matt@bluehost.com
In-Reply-To: <4849E09D.6090804@firstfloor.org>
References: <20080605194334.GA56830@perlcode.org>
	 <87d4muu0k2.fsf@basil.nowhere.org> <20080606204704.GA4330@perlcode.org>
	 <4849E09D.6090804@firstfloor.org>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 08:20:29 -0600
Message-Id: <1213021229.4645.67.camel@tub.office.bluehost.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-35.0.4.el4_6.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-07 at 03:13 +0200, Andi Kleen wrote:
> Scott Wiersdorf wrote: 
> > I still think a single handler is elegant enough though, and works
> > better with many log rotation systems that want to send a single
> > signal to a pid (it's what we need where I'm working now, hence the
> > patch).
> 
> Well in general it would be cool if there was nicer free userland for
> the obscure but useful delay accounting. The code in Documentation
> is really not much more than a example. Do you have something downloadable?

I don't. I'm really not much of a C programmer; I'm just hacking on this
file for our company because we have a use for it. I'm all for it going
into userland, but don't have the time to be responsible for that.

Scott


