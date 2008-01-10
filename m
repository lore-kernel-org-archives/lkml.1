Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbYAJFGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbYAJFGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 00:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYAJFGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 00:06:32 -0500
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:49473 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbYAJFGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 00:06:31 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 00:06:31 EST
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Date: Wed, 9 Jan 2008 20:59:46 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Chris Friesen <cfriesen@nortel.com>, Andi Kleen <andi@firstfloor.org>,
       Matt Mackall <mpm@selenic.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       gorcunov@gmail.com
References: <20080108164015.GC31504@one.firstfloor.org> <200801091531.00483.vlobanov@speakeasy.net> <20080110000043.GI3510@agk.fab.redhat.com>
In-Reply-To: <20080110000043.GI3510@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801092059.46884.vlobanov@speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008 04:00:43 pm Alasdair G Kergon wrote:
> On Wed, Jan 09, 2008 at 03:31:00PM -0800, Vadim Lobanov wrote:
> > From 2.6.23's fs/ioctl.c - do_ioctl():
>
> Ah - you're talking about struct file_operations of course;
> I was talking about struct block_device_operations.
>
> Alasdair

Good point. :-)

-- Vadim Lobanov
