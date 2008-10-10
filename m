Return-Path: <linux-kernel-owner+w=401wt.eu-S1761545AbYJJQXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761545AbYJJQXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759472AbYJJQXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:23:39 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:63474 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbYJJQXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:23:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Cdg3DTyIDHLHnBhVr0WZk7B74vxb/w8B9FhCjyXIot2BxkP1A/v2/X1EUag3to0z4Q
         KZXx6Izo2aoYkkI0Hv/WSBl4cuPIALtlTKbXlKLH25WIJdnWYWOPxCgm2sybJglUa3+l
         zr2FV5g8RN6exztcrqddgvy+aThLfcyaUXuNM=
Message-ID: <f7848160810100923j12c03769x1a05ed7091e67a1b@mail.gmail.com>
Date: Fri, 10 Oct 2008 12:23:36 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] WARNING: at kernel/power/main.c:176 suspend_test_finish+0x70/0x80()
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0810101028260.2459-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810101452.27929.rjw@sisk.pl>
	 <Pine.LNX.4.44L0.0810101028260.2459-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 10:31 AM, Alan Stern <stern@rowland.harvard.edu> wrote:

> There's a bug that affects USB power management: commmit
> f9dd45ce10a014bdfd5432828c44630ea7fefedd needs to be reverted.  Greg KH
> has been asked to do this a few times but he hasn't gotten around to it
> yet.

Hi Alan,

Thanks for the info.

I can't seem to find that commit in mainline. If you have pointer to
the patch I will submit a revert.

Parag
