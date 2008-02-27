Return-Path: <linux-kernel-owner+w=401wt.eu-S1762988AbYB0IjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762988AbYB0IjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 03:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYB0IjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 03:39:13 -0500
Received: from web52909.mail.re2.yahoo.com ([206.190.49.19]:41097 "HELO
	web52909.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752659AbYB0IjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 03:39:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=drXemD0S+pHEKW4QH7jqDcC2eLEoa0pAfKvw2mMUtzWYEaTu3IySEROhDISZ2mhKLNTxNbwSZyKB1njCY0a5lcHhXMrCOOht6BbbWGWfHeNJE1Jh7tYyt3K+0jo52184qGAq8RdkXvB1DDvI0fendQlY6VUIFlx/2P1dbxJp10s=;
X-YMail-OSG: B4b4XLMVM1l_WtbmsFYzr6zdzm.zDLe8ggVcmTU.
Date: Wed, 27 Feb 2008 08:39:11 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Linux 2.6.24.1  - kernel does not boot; IRQ trouble?
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080226185216.f298784d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <952958.61284.qm@web52909.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Andrew Morton <akpm@linux-foundation.org> wrote:
> You reported this regression nearly a month ago and apart from me flailing
> around nobody has bothered to do the slightest thing about it.

Yes, I've noticed. Am I the only person hitting this then?

> If you can identify the offending commit (see
> http://www.kernel.org/doc/local/git-quick.html) we'll get it working again
> and I really don't care how many commits we have to revert to do it.

I'm not sure about a complete git installation, but I should at least be able to find the last
working 2.6.23-gitX or 2.6.24-rcX-gitY tree. (Assuming that these are the intermediate steps
between 2.6.23 and 2.6.24.)

Cheers,
Chris




      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Inbox. http://uk.docs.yahoo.com/nowyoucan.html
