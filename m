Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYG2Q1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYG2Q1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYG2Q1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:27:17 -0400
Received: from outbound-mail-144.bluehost.com ([67.222.38.34]:48441 "HELO
	outbound-mail-144.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751188AbYG2Q1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:27:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Jq/gyaQssGA2H8o2YE/nW/lShw2qT2xBpDaTqePbexyTUZ/hSGUh7E5tiefpD/17bleLTwifMuYkZcqAIGs1/XSQCQCsTMVbtTX/0OOhIzTgYDX+0IcCxKRv1IzsSM0g;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux v2.6.27-rc1
Date: Tue, 29 Jul 2008 09:27:11 -0700
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807290927.12101.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 28, 2008 8:23 pm Linus Torvalds wrote:
> Much of -rc1 was in linux-next, but certainly not everything. We'll see
> how that whole thing ends up evolving - it certainly didn't solve all
> problems, and there was some bickering about things that weren't there
> (and some things that mostly were ;), but maybe it helped.

I think linux-next has been a *huge* help.  It's been great at catching merge 
conflicts and build bugs (though not so much when you don't use it[1]!), and 
Stephen is really easy to work with.  So I, for one, would love to see it 
continue.

Jesse

[1] http://marc.info/?t=121699085400001&r=1&w=2
