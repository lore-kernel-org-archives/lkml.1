Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbYG1Qyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbYG1Qyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYG1Qyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:54:43 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:51508 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbYG1Qym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:54:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=II/Pg8U7vaKVI3qgt8g3v+VLci7Pp6XvKqlGiPk0gdd7HvGKlS9STVm8ipLkwS1BeIkHjeeIJP6lEPJHdNu9aVYcgwSyqPTFmHgy6qoXJMhNMqfmH44AZDgBttLmIz9M;
Message-ID: <488DF9CF.8020408@simon.arlott.org.uk>
Date: Mon, 28 Jul 2008 17:54:39 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
In-Reply-To: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/08 15:45, Jon Smirl wrote:
> Here's a new .mailmap file for the kernel that cleans up the horrible
> mess of names and email addresses in the log.  To use it put it at the
> root of your kernel tree and type 'git shortlog'. Before the clean up
> there were 4,284 developers, after 3,821. There are 5,051 unique
> emails.
> 
> The mailmap file contains all email addresses that have been used to
> submit patches to the kernel. Don't freak out about your email address
> being in the file, if it is in the file it is already in Google since
> the kernel log is already in Google.

Just because anyone can grep the kernel log for email addresses [to 
send spam to], doesn't mean that you need to do it for them.

Please read git-shortlog(1) and then remove me from this file because 
it won't change anything.

-- 
Simon Arlott
