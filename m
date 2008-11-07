Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbYKGTPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbYKGTPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYKGTPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:15:22 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51581
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYKGTPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:15:21 -0500
From: Rob Landley <rob@landley.net>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC] Documentation tree sub-directories reorg.
Date: Fri, 7 Nov 2008 13:17:17 -0600
User-Agent: KMail/1.9.9
Cc: Randy Dunlap <rdunlap@xenotime.net>, lkml <linux-kernel@vger.kernel.org>,
       linux-doc@vger.kernel.org, mtk.manpages@gmail.com,
       alan@lxorguk.ukuu.org.uk
References: <4910D1BC.9060100@xenotime.net> <20081104162345.38729b20@bike.lwn.net>
In-Reply-To: <20081104162345.38729b20@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811071317.19159.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 November 2008 17:23:45 Jonathan Corbet wrote:
> On Tue, 04 Nov 2008 14:50:36 -0800
>
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> > I would like to use a few more sub-directories in the Documentation/
> > tree to try to help clean it up some.  E.g., move some drivers/block/
> > doc files to Documentation/blockdev/ and move some serial/tty/chardev
> > doc files to Documentation/serial/
>
> This all makes fine sense to me, but I do wonder if we shouldn't also
> create an "obsolete" subdirectory and put some of those files there?
> For example, paride.txt starts off this way:
>
> 	Owing to the simplicity and near universality of the parallel port
> 	interface to personal computers, many external devices such as
> 	portable hard-disk, CD-ROM, LS-120 and tape drives use the parallel
> 	port to connect to their host computer.
>
> Said ports are not quite as universal as they once were.

Yeah, but the robotics guys guys love 'em as a really easy way to get 
controllable pinouts from PC hardware. :)

No objection to the idea of a place to put obsolete docs, 
although "deprecated" might be a better name and it seems like it relates to 
feature-removal-schedule.txt somehow...

Rob
