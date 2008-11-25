Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbYKYHKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbYKYHKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYKYHK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:10:27 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3251 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbYKYHKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:10:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Trilok Soni" <soni.trilok@gmail.com>
Subject: Re: v4l2_device/v4l2_subdev: please review
Date: Tue, 25 Nov 2008 08:10:01 +0100
User-Agent: KMail/1.9.9
Cc: v4l <video4linux-list@redhat.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       linux-kernel@vger.kernel.org
References: <200811242309.37489.hverkuil@xs4all.nl> <5d5443650811242251g5ddda028q9413b0ff47fc08a8@mail.gmail.com>
In-Reply-To: <5d5443650811242251g5ddda028q9413b0ff47fc08a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811250810.01767.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2008 07:51:25 Trilok Soni wrote:
> Hi Hans,
>
> On Tue, Nov 25, 2008 at 3:39 AM, Hans Verkuil <hverkuil@xs4all.nl> 
wrote:
> > Hi all,
> >
> > I've finally tracked down the last oops so I could make a new tree
> > with all the latest changes.
>
> Please send these patches to mailing list (git-send-email?) for easy
> review. Also CCing LKML for wider view is also good, as we are doing
> some core changes right?

I'm not going to spam the list with these quite big patches. Just go to 
http://linuxtv.org/hg/~hverkuil/v4l-dvb-ng/ and click on the 'raw' link 
after each change to see the patch. Most of these changes are just 
boring i2c driver conversions.

We are adding to the v4l core, but the changes do not affect existing 
v4l drivers let alone other subsystems. Although I should probably have 
added the omap list.

Regards,

	Hans
