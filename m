Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbXCPKwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbXCPKwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbXCPKwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:52:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:64924 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbXCPKwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dTTSBiizFSl1PulqPUusoJ7Vyx1bZqoV3azwBiO8bUKlGtDSsgdzrqnAdHlPfvuLyNkdvcvktiHaS1W369n5fElsxSIu2P2BEpbKv3USZiXDL/vo/aHgkbE+aYbPRCQAQ1HkBVzF0Fcp7oki9bluXNGb7kU8+6oyjsMLej/ewpA=
Message-ID: <4af2d03a0703160352m71259c71l54e616ff1aee3e65@mail.gmail.com>
Date: Fri, 16 Mar 2007 11:52:01 +0100
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
Cc: "Jiri Kosina" <jikos@jikos.cz>, linux-kernel@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0703151556420.2482-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4af2d03a0703130913n3f51a3ffiec6e498c56a34826@mail.gmail.com>
	 <Pine.LNX.4.44L0.0703151556420.2482-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> By the way, what happens if you press CapsLock rather than NumLock?  It
> should behave pretty the same, sending a command to the keyboard to change
> an LED setting.  Does the keyboard then stop working in the same way?

Yes, and hence the *lock in the subject of the message, i.e. Capslock
behaves exactly the same.

I'll test the attached patch today or tomorrow.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
