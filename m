Return-Path: <linux-kernel-owner+w=401wt.eu-S936412AbYBVBIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936412AbYBVBIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761754AbYBVBIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:08:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39576 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762754AbYBVBIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:08:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
Date: Fri, 22 Feb 2008 02:06:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Jesse Barnes" <jesse.barnes@intel.com>,
       "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Dave Airlie" <airlied@linux.ie>, "Greg KH" <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <b6a2187b0802211642i7f4cd764ocb5a66b49de78875@mail.gmail.com> <b6a2187b0802211701p59b427aft694ace922e8c3c90@mail.gmail.com>
In-Reply-To: <b6a2187b0802211701p59b427aft694ace922e8c3c90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802220206.43024.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of February 2008, Jeff Chua wrote:
> On Fri, Feb 22, 2008 at 8:42 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > On Fri, Feb 22, 2008 at 8:31 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> >  >  Jeff, can you please test hibernation with the patch I've just sent to Jesse
> >  >  (reproduced below for convenience)?
> >
> >  Testing now.
> 
> Great news. It works. STD (platform) does not hang at suspend. And the
> annoying green is gone! STR still works.

Great, thanks for testing.

If Jesse confirms that it also works for him, I'll prepare a cleaner final fix
tomorrow.

Thanks,
Rafael
