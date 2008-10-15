Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYJORnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYJORnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYJORnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:43:33 -0400
Received: from kroah.org ([198.145.64.141]:54676 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752479AbYJORnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:43:32 -0400
Date: Wed, 15 Oct 2008 10:40:15 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: is the weeks before -rc1 the time to really be working on -next?
Message-ID: <20081015174015.GB8663@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just wondering, I know that -next is failing right now, and is a major
pain to produce, but that seems to be primarily due to all of the
subsystems merging with Linus right now.

So does it even make sense to try to create a -next during the 2 weeks
of the major merge window?  It seems to just cause you a whole lot of
work, that in the end, is mostly unecessary as all of the subsystem
maintainers are doing the merging themselves as trees move into Linus's
tree?

thanks,

greg k-h
