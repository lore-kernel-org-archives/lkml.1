Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbXJ3Hy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbXJ3Hy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 03:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbXJ3Hys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 03:54:48 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:34513 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754347AbXJ3Hyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 03:54:47 -0400
Message-ID: <4726E36F.6030909@crispincowan.com>
Date: Tue, 30 Oct 2007 00:55:27 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Cliffe <cliffe@ii.net>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: Defense in depth: LSM *modules*, not a static interface
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl> <4726377A.4080807@crispincowan.com> <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com> <4726D9D9.2000909@ii.net> <20071030065540.GH8181@ftp.linux.org.uk>
In-Reply-To: <20071030065540.GH8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Tue, Oct 30, 2007 at 03:14:33PM +0800, Cliffe wrote:
>   
>> Defense in depth has long been recognised as an important secure design 
>> principle. Security is best achieved using a layered approach.
>>     
>  "Layered approach" is not a magic incantation to excuse any bit of snake
> oil.  Homeopathic remedies might not harm (pure water is pure water),
> but that's not an excuse for quackery.  And frankly, most of the
> "security improvement" crowd sound exactly like woo-peddlers.
>   
Frank's point was that the static interface makes layering somewhere
between impractical and impossible. The static interface change should
be dumped so that layering is at least possible. Whether any given
security module is worth while is a separate issue.

I.e. that there are bad medicines around is a poor excuse to ban
syringes and demand that everyone be born with a strong immune system.

Why is it that security flame wars always end up reasoning with absurd
analogies? :-)

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

