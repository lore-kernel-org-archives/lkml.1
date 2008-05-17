Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYEQNdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYEQNdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 09:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYEQNc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 09:32:58 -0400
Received: from fmailhost02.isp.att.net ([204.127.217.102]:43668 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753251AbYEQNc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 09:32:57 -0400
X-Originating-IP: [70.152.106.225]
Date: Sat, 17 May 2008 08:32:54 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: Chris Rankin <rankincj@yahoo.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
Message-ID: <20080517083254.4eb6e07d@osprey.hogchain.net>
In-Reply-To: <20080517082207.4b1e8556@osprey.hogchain.net>
References: <20080516123321.5674952c@osprey.hogchain.net>
	<762763.57234.qm@web52903.mail.re2.yahoo.com>
	<20080517082207.4b1e8556@osprey.hogchain.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 08:22:07 -0500
Jay Cliburn <jacliburn@bellsouth.net> wrote:

> On Sat, 17 May 2008 13:29:31 +0100 (BST)
> Chris Rankin <rankincj@yahoo.com> wrote:
> 
> > --- Jay Cliburn <jacliburn@bellsouth.net> wrote:
> > > Serial console using minicom works fine for me under 2.6.25 and
> > > 2.6.25.4.  Keystrokes are accepted normally.
> > 
> > I have just replicated this problem between two Fedora 8 boxes;
> > minicom reads the remote serial console fine, provided it is running
> > on a 2.6.24.x kernel. (The serial console is from a 2.6.25.4
> > machine.)

> Mine still works.  I was going to bisect it, but I don't encounter the
> problem.

Another bit of info, FWIW: unlike your setup, the system at the other
end of my null modem cable is running Fedora 9, not Fedora 8.
