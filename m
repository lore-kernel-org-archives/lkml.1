Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYKGArA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYKGArA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYKGAqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 19:46:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbYKGAqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 19:46:52 -0500
Date: Thu, 6 Nov 2008 16:46:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: mitake@clustcom.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, ktaka@clustcom.com
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081106164641.ed369060.akpm@linux-foundation.org>
In-Reply-To: <413709.12821.qm@web50106.mail.re2.yahoo.com>
References: <20081105222911.d76e7e1c.mitake@clustcom.com>
	<413709.12821.qm@web50106.mail.re2.yahoo.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008 08:26:12 -0800 (PST)
Doug Thompson <norsk5@yahoo.com> wrote:

> > I wrote new version of this driver and tested. It works well.
> > This is replacement for old version.
> > Or should I send diff of two versions?
> 
> 
> I would suggest sending a diff of what is now in the -mm tree to what it should be.

This driver is now in the mainline kernel so yes, a patch against that
kernel is the only appropriate way of updating the driver.

