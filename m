Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbXENTIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbXENTIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbXENTIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:08:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbXENTIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:08:31 -0400
Date: Mon, 14 May 2007 15:08:25 -0400
From: Dave Jones <davej@redhat.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Barry Scott <barry.scott@onelan.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Opss: 2.6.21-1.3116.ONELAN Kernel last sysfs file: /class/vc/vcsa7/dev
Message-ID: <20070514190825.GD29024@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Barry Scott <barry.scott@onelan.co.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <46483868.5040106@onelan.co.uk> <6bffcb0e0705140340m228e8e62n5053db88deadf5fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0705140340m228e8e62n5053db88deadf5fd@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 12:40:48PM +0200, Michal Piotrowski wrote:
 > Hi Barry,
 > 
 > On 14/05/07, Barry Scott <barry.scott@onelan.co.uk> wrote:
 > > I'm testing the robustness of Xorg 1.3 server with intel 2.0 driver
 > > by restarting the X and a set of apps every 30 seconds. After
 > > about an hour this happened.
 > >
 > > 2.6.21-1.3116.ONELAN is the same as 2.6.21-1.3116 from FC7
 > > but with the spec file change so that we can run the kernel on an FC4
 > > system.
 > 
 > Ok, it's Fedora 7 kernel, so please visit
 > https://bugzilla.redhat.com/bugzilla/index.cgi

For all intents and purposes here, that may as well be a vanilla 2.6.21.1
Reporting it there isn't going to get much more than a "*shrug* ask upstream"
from me.

	Dave

-- 
http://www.codemonkey.org.uk
