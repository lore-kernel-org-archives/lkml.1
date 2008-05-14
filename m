Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbYENXg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbYENXg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 19:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYENXgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 19:36:18 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3982 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYENXgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 19:36:17 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <pavel@ucw.cz>
Cc: "pradeep singh rautela" <rautelap@gmail.com>, <hjk@linutronix.de>,
       "Greg KH" <greg@kroah.com>, <linux-kernel@vger.kernel.org>
Subject: RE: [Q]Can a file be dual licensed in upstream kernel?
Date: Wed, 14 May 2008 16:36:14 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEEJMKAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <20080514152834.GA6888@ucw.cz>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 14 May 2008 16:37:37 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 14 May 2008 16:37:38 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu 2008-05-01 07:59:54, David Schwartz wrote:

> > In my _personal_opinion_, dual licensing gives you the right to choose
> > between two licenses.

> > Dual licensing gives every recipient both licenses from the
> > original author.
> > You can choose which license you will obtain rights from.
> >
> > > If a file is dual licensed BSD/GPLv2, anybody
> > > (including yourself) is free to get rid of the BSD part and make it
> > > GPLv2 only.

> > Really? Which license or law gives you the right to change the licensing
> > terms on code you didn't write? At least in the United States,
> > you cannot

> You don't change licensing. You got choice of two licenses, and you
> selected one. GPL gives you right to remove the BSD licensing terms
> you did not choose.

GPL gives you the right to remove the BSD licensing *TERMS*, but this has no
effect on the actual license. The works do not become GPLv2 only just
because you removed the licensing terms.

> (People still can use the code under BSD license _if_ they know it was
> originally BSD/GPL.. as long as you don't modify it).

Exactly. So you *cannot* change the license, you can only remove the
licensing terms. And even if you do modify it, that still has no effect on
the available licenses for any creative elements you did not author.

"6. Each time you redistribute the Program (or any work based on the
Program), the recipient automatically receives a license from the
original licensor to copy, distribute or modify the Program subject to
these terms and conditions."

For both the GPL and the BSD license, anyone who receives covered works or
elements receives the offered licenses directly from the original author.
There is nothing you can do to change this.

Neither the BSD license nor the GPL license allow you to in any way modify
the license or licenses offered by anyone else to creative elements they
authored. In the United States, at least, this is not even possible without
a written re-licensing agreement. The licenses always flow from each
creative element's original author to the final end user. Distributors
simply provide copies of the works, they do *NOT* relicense them. People who
modify the works simply add and license other creative elements, they do not
relicense the existing ones.

DS


