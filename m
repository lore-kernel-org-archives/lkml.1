Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYKLVcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYKLVcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYKLVca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:32:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59700 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYKLVc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:32:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Date: Wed, 12 Nov 2008 22:37:02 +0100
User-Agent: KMail/1.9.9
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Mathieu Chouquet-Stringer" <mchouque@free.fr>,
       Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
References: <20081109195033.GA1335@mobydick> <200811121033.58840.jbarnes@virtuousgeek.org> <20081112184236.GR26778@kernel.dk>
In-Reply-To: <20081112184236.GR26778@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122237.03882.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 12 of November 2008, Jens Axboe wrote:
> On Wed, Nov 12 2008, Jesse Barnes wrote:
> > On Tuesday, November 11, 2008 7:27 am Mathieu Chouquet-Stringer wrote:
> > > On Tue, Nov 11, 2008 at 12:15:24AM +0100, Mathieu Chouquet-Stringer wrote:
> > > > This one I guess:
> > > > http://bugzilla.kernel.org/attachment.cgi?id=18644&action=view
> > > >
> > > > Let me give it a shot, I'll keep you posted.
> > >
> > > So I compiled the module, rebooted just to have a clean starting point,
> > > started X then tried to suspend: no go...
> > 
> > Dave pushed a fix for this (more complete than the one in the patch you 
> > reference), have you tried the kernel from today to see if things work now?
> 
> A drm enabled kernel also hangs hard on resume (just see the mouse
> pointer) here on the x60. Removing drm makes it work just fine. 2.6.27
> works fine as well.

Is there Intel graphics in there?

Rafael
