Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYAYTSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYAYTSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYAYTSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:18:10 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42767 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbYAYTSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:18:09 -0500
Date: Fri, 25 Jan 2008 13:14:07 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Hellewell <phillip@hellewell.homeip.net>
Subject: Re: [PATCH 076/196] ecryptfs: remove version_str file from sysfs
Message-ID: <20080125191407.GL25594@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080125071127.GA4860@kroah.com> <1201245134-4876-76-git-send-email-gregkh@suse.de> <47999CF2.9070805@garzik.org> <20080125175421.GD4242@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125175421.GD4242@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 09:54:21AM -0800, Greg KH wrote:
> I could not find any userspace tools or documentation that used it

The version_str handle is only there as a potential convenience for
users who need to figure out what their module can and cannot do. I
mentioned it in an article in LJ last year. It does not need to be
there for any tools to work right, and I do not think that anyone
really cares about it at this point, so I have no problem with just
ripping it out.

Mike
