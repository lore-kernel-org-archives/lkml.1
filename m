Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYGSAxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYGSAxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 20:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYGSAxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 20:53:44 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1484 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYGSAxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 20:53:43 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2008 20:53:43 EDT
From: "David Schwartz" <davids@webmaster.com>
To: "Greg KH" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, <stable@kernel.org>
Subject: RE: [stable] Linux 2.6.25.10
Date: Fri, 18 Jul 2008 17:47:45 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEJCOEAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20080714120418.GA5334@kroah.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 18 Jul 2008 17:49:49 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 18 Jul 2008 17:49:50 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg KH wrote:

> Personally, I omit posting full "and here is explicitly how to exploit
> this problem" notices as that is foolish.

That means only people with the time, energy, and expertise to create an
exploit will have an exploit. This includes probably 90% of the people who
would use the exploit maliciously and 100% of the people who pose a real
thread to the community. It does, however, ensure that the majority of
ordinary users won't be able to test their systems to see if they're
vulnerable or if the vulnerability is fixed. So at least it will have some
effect.

DS


