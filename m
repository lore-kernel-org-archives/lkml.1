Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751780AbYLQSIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbYLQSIW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbYLQSIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:08:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48864 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYLQSIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:08:10 -0500
Date: Wed, 17 Dec 2008 18:08:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, v4l <video4linux-list@redhat.com>,
        Laurent Pinchart <laurent.pinchart@skynet.be>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [BUG] cdev_put() race condition
Message-ID: <20081217180805.GG28946@ZenIV.linux.org.uk>
References: <200812082156.26522.hverkuil@xs4all.nl> <200812171607.41713.hverkuil@xs4all.nl> <49492437.7020105@panasas.com> <200812171833.39735.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812171833.39735.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 06:33:38PM +0100, Hans Verkuil wrote:
> On Wednesday 17 December 2008 17:09:27 Boaz Harrosh wrote:
> > Hans Verkuil wrote:
> > > On Wednesday 17 December 2008 15:52:38 Boaz Harrosh wrote:
> > >> Hans Verkuil wrote:
> > >>> On Wednesday 17 December 2008 00:30:39 Greg KH wrote:
> > >>>> On Wed, Dec 17, 2008 at 12:23:41AM +0100, Hans Verkuil wrote:
> > >>>>> On Tuesday 16 December 2008 22:21:50 Greg KH wrote:
> > >>>>>> On Tue, Dec 16, 2008 at 10:00:51PM +0100, Hans Verkuil wrote:
> > >>>>>>> On Tuesday 16 December 2008 21:22:48 Greg KH wrote:
> > >>>>>>>> On Mon, Dec 08, 2008 at 09:56:26PM +0100, Hans Verkuil wrote:
> > >>>>>>>>> Hi Greg,

[snip 400-odd lines, with ~30 lines of original contents]

Could the esteemed sir kindly consider trimming the fucking crap or taking
that to alt.cascade?
