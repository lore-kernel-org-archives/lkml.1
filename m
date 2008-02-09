Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYBISWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYBISWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 13:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYBISWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 13:22:35 -0500
Received: from web52902.mail.re2.yahoo.com ([206.190.49.12]:22227 "HELO
	web52902.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753330AbYBISWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:22:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=HN66mSjdLauzvNzM7L14ZVqCYJs+2JO7vqL1T4NBEfqw01bvoywJ2QLXYEnUNO/mG2pK/nH6QlnDBZ+M4vIaRtcA28n93bvRwV5LlevPmweBWpnoN/EpwY12O0N1JCgipbZjBedaKuChfPGlkDD+18j6F0+aRVwW6wSGkLnSst4=;
X-YMail-OSG: eT6OUOsVM1ncJul4TEn59DT1BG1sHDiUu2tOtM9.b7P.H4xhiJOQOG6aqtUbol_zG67dYB5v.mE6usF2EzoMTyYncSwIfMJHZNHx5kn5YjwegMXpvaVNK2_9wndCvuZ5oDYnMQ49rWN1WDv2jEvP
Date: Sat, 9 Feb 2008 18:22:32 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Linux 2.6.24.1  - kernel does not boot; IRQ trouble?
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20080209180633.GB20784@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <869708.29623.qm@web52902.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Greg KH <greg@kroah.com> wrote:
> Does any older kernel version work?  2.6.23?  Newer ones?
Everything up to and including 2.6.23.11 works fine. I never tried 2.6.23.{12,13,14,15}, but I
expect they're fine too.

>  2.6.24-git15?
No idea. This box isn't really set up to use git. Anyway, I would refer you to this thread:
http://www.uwsg.iu.edu/hypermail/linux/kernel/0802.0/0898.html

Cheers,
Chris



      ___________________________________________________________
Support the World Aids Awareness campaign this month with Yahoo! For Good http://uk.promotions.yahoo.com/forgood/
