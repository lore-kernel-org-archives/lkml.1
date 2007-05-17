Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbXEQLKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbXEQLKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 07:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbXEQLK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 07:10:29 -0400
Received: from c2bthomr04.btconnect.com ([213.123.20.136]:13737 "EHLO
	c2bthomr04.btconnect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbXEQLK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 07:10:28 -0400
Message-ID: <464C380E.6080604@onelan.co.uk>
Date: Thu, 17 May 2007 12:10:06 +0100
From: Barry Scott <barry.scott@onelan.co.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Barry Scott <barry.scott@onelan.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Opss: 2.6.21-1.3116.ONELAN Kernel last sysfs file: /class/vc/vcsa7/dev
References: <46483868.5040106@onelan.co.uk> <6bffcb0e0705140340m228e8e62n5053db88deadf5fd@mail.gmail.com> <20070514190825.GD29024@redhat.com>
In-Reply-To: <20070514190825.GD29024@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Junkmail-Status: score=10/50, host=c2bthomr04.btconnect.com
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A090201.464C3817.00D0,ss=1,fgs=0,
	ip=217.35.101.6,
	so=2006-12-09 10:45:40,
	dmn=5.3.10/2007-02-21
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Mon, May 14, 2007 at 12:40:48PM +0200, Michal Piotrowski wrote:
>  > Hi Barry,
>  > 
>  > On 14/05/07, Barry Scott <barry.scott@onelan.co.uk> wrote:
>  > > I'm testing the robustness of Xorg 1.3 server with intel 2.0 driver
>  > > by restarting the X and a set of apps every 30 seconds. After
>  > > about an hour this happened.
>  > >
>  > > 2.6.21-1.3116.ONELAN is the same as 2.6.21-1.3116 from FC7
>  > > but with the spec file change so that we can run the kernel on an FC4
>  > > system.
>  > 
>  > Ok, it's Fedora 7 kernel, so please visit
>  > https://bugzilla.redhat.com/bugzilla/index.cgi
>
> For all intents and purposes here, that may as well be a vanilla 2.6.21.1
> Reporting it there isn't going to get much more than a "*shrug* ask upstream"
> from me.
>
>   
Indeed I'm sure Fedora would point me here.

Anyone have any idea what wrong?

Barry

