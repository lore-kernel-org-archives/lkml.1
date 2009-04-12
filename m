Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbZDLQtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbZDLQtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 12:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbZDLQtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 12:49:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36902 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbZDLQtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 12:49:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: suspend-to-ram broken on X61 thinkpads in 2.6.30-rc1?
Date: Sun, 12 Apr 2009 18:49:12 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-rjw; KDE/4.2.2; x86_64; ; )
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
References: <E1Ls9pZ-0004IF-FZ@closure.thunk.org> <200904111251.49396.rjw@sisk.pl> <20090411223311.GA10547@mit.edu>
In-Reply-To: <20090411223311.GA10547@mit.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904121849.13477.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 April 2009, Theodore Tso wrote:
> On Sat, Apr 11, 2009 at 12:51:48PM +0200, Rafael J. Wysocki wrote:
> > 
> > Great, thanks for checking this.
> > 
> > Ted, can you please see if the current -git fixed the problem for you too?
> > 
> 
> Confirmed, it seems to be fixed.

Great, thanks!

Rafael
