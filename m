Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbXICCCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbXICCCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXICCBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:01:32 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2190 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbXICCB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:01:29 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: That whole "Linux stealing our code" thing
Date: Sun, 2 Sep 2007 19:01:16 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKECFGJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 02 Sep 2007 19:02:04 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 02 Sep 2007 19:02:05 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> - If you receive dual licensed code, you may not delete the license
>   you don't like and then distribute it.  It has to stay, because you
>   may not edit someone's else's license -- which is a three-part legal
>   document (For instance: Copyright notice, BSD, followed by GPL).

This is absolute nonsense. By default, you can remove a license if you want
to. This is why both the GPL and the BSD licenses have clauses requiring you
to leave them in.

A file that is under a dual license may be used under either the GPL license
or the BSD license. Neither license requires you to retain the *other*
license in the file. So there is absolutely no reason you cannot remove one
license or the other. To argue otherwise is to argue that you need to comply
with *both* licenses in a dual-licensed file to get the rights granted by
either, and that's nonsense.

You cannot, of course, modify a license and expect your modified license to
apply to protectable elements you didn't author. And anyone who receives
modified versions of the file still has all the rights the original authors
grant them.

Let's perform a thought experiment for a moment. Suppose the BSD license
explicitly said you could remove the licensing clause if you wanted to.
Would you still argue that you couldn't remove it even though it says you
can? Well, the GPL says you can modify anything you want to, except *THAT*
license. This means you can remove any other license notifications you want.

Note that your license editing or removing has no effect on the rights
people actually get except to your code.

DS


