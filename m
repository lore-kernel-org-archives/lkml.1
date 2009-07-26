Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbZGZFYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbZGZFYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 01:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZGZFYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 01:24:08 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:35689 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZGZFYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 01:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=tgbyTJraaOhI9BBNk+BYLZy/RqqSYqu1j5UR/ymSmYnpCz9l29nHrSFvXIMjBQdECs
         XK76pR4cCR8dm4EkLiYvCDsae0YgM/r59WNAopIirzE6KguoWrTeLhujswOfCoULYDZP
         sofm19jdN/CsMAxork3uCGfX/Zjg/8ETZRLsQ=
Date: Sun, 26 Jul 2009 01:24:03 -0400
From: Celejar <celejar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: suspend to disk now broken
Message-Id: <20090726012403.2c4c332a.celejar@gmail.com>
In-Reply-To: <200907260018.03705.rjw@sisk.pl>
References: <20090712151947.25446ceb.celejar@gmail.com>
	<200907260018.03705.rjw@sisk.pl>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009 00:18:03 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 12 July 2009, Celejar wrote:
> > Hi,
> > 
> > A recent change to the kernel has apparently broken suspend to disk on
> > my machine.  It still works fine in 2.6.30.1, but hangs during the
> > 'devices' phase of suspension with 2.6.31-rc2.  [I originally saw the

...

> Well, I guess it's still a problem with 2.6.31-rc4?

As we discussed earlier, the problem seems to have been resolved with
-rc3. I have just tested with -rc4, and that works fine, too.

Celejar
--
mailmin.sourceforge.net - remote access via secure (OpenPGP) email
ssuds.sourceforge.net - A Simple Sudoku Solver and Generator

