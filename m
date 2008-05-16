Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYEPH2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYEPH2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 03:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYEPH2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 03:28:46 -0400
Received: from web52910.mail.re2.yahoo.com ([206.190.49.20]:44382 "HELO
	web52910.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751960AbYEPH2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 03:28:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=rdfQxyoy3XX9ySjc2TDTiLi65A1uwgiTyEPdyTKFxA5OJdWb2wcegrIiua4gtSQf4NZj8u+5U7oxmw4CpRvJtYAPmEX0hKk+D0QhevPKrENKdKBPNnKFrhKHo/UaZZ6V+lJob1w9PFIzGeJe4UTLdOVbejAHE1nBxhxjlCtIuEs=;
X-YMail-OSG: 8.OXKU0VM1lpcYzyhAhO.7CT2MsznnG8LKR_fh6pHBzWmEhvVxjpmBgnzkcJZ6.vnOlApZwC9l9UpY6MZ.q7sRbbO5yq7EmHIgQK3ZAaakNTD8Se_b1jqInVrg--
Date: Fri, 16 May 2008 08:28:41 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 2.6.25.3: serial problem (minicom)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
In-Reply-To: <20080515202300.4d0465ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <150988.90868.qm@web52910.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Andrew Morton <akpm@linux-foundation.org> wrote:
> All of which builds up to the dreaded....  would you be able to perform
> a bisection search to work out which commit caused this?
> http://www.kernel.org/doc/local/git-quick.html has instructions.

Can't you just send me those 4 serial patches instead, and I'll try backing them out one by one?

I have another pair of boxes both running Fedora 8 that I'll try replicating this on, just in case
there's something dodgy about my machine's userspace environment.

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Email http://uk.docs.yahoo.com/nowyoucan.html
