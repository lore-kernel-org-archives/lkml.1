Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbYAIAxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbYAIAxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYAIAxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:53:14 -0500
Received: from mail.davidb.org ([66.93.32.219]:38788 "EHLO mail.davidb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYAIAxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:53:13 -0500
X-Greylist: delayed 1995 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 19:53:13 EST
Date: Tue, 8 Jan 2008 16:19:48 -0800
From: David Brown <mtd@davidb.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Claim maintainership for block2mtd and update email
	addresses
Message-ID: <20080109001948.GA16644@old.davidb.org>
References: <20080106135600.GB3120@lazybastard.org> <20080107152300.2ed7cddb.akpm@linux-foundation.org> <20080108010656.GA10627@lazybastard.org> <Pine.LNX.4.64.0801090016570.10908@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0801090016570.10908@axis700.grange>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 12:23:24AM +0100, Guennadi Liakhovetski wrote:

>On Tue, 8 Jan 2008, Jörn Engel wrote:
>
>> I'm happy if people spend effort and make unicode work.  Until then I'll
>> semi-officially change my name to "Joern" and keep collecting unusual
>> specimens.
>
>Just wondering - nothing personal at all. What's the official plan for 
>this - do we want (when utf8 works) to use utf8 codes for symbols only for 
>languages mostly based on ASCII, like iso-8859-15, or for all?

UTF-8 already works fine in git.  There is some support in recent versions
to allow commit messages and users to be specified in other encodings.

I think the issue here is with mailers modifying the encoding of data in
message files.

My reply header should be to Jörn, with a proper 'o' with two dots over it.
By default, my mailer wants to encode the message in iso-8859-1.  If I add
a single unicode character, say '‣', then the whole message will get
encoded in UTF-8.

UTF-8 has the advantage of supporting nearly all character sets.  The extra
space needed isn't really an issue for usernames or for comment messages.

Dave
