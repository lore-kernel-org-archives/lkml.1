Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYKLSeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYKLSeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYKLSeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:34:12 -0500
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:37771 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751261AbYKLSeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:34:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=McManZHCYWfKgpwGtfK62afCSsOGXnwTSl9oKGzoWwvqD8F/nxVfjP+aysSVWoqT1Jo6lVSAGD/cf6qHLS4dCr9NxvtjpWkf1qyo9VtPaVTL62QO/jcKp2LVVky34Wlw;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Mathieu Chouquet-Stringer" <mchouque@free.fr>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Date: Wed, 12 Nov 2008 10:33:58 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.6-79.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
References: <20081109195033.GA1335@mobydick> <20081110231524.GA18971@mobydick> <20081111152736.GA28569@mobydick>
In-Reply-To: <20081111152736.GA28569@mobydick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811121033.58840.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 11, 2008 7:27 am Mathieu Chouquet-Stringer wrote:
> On Tue, Nov 11, 2008 at 12:15:24AM +0100, Mathieu Chouquet-Stringer wrote:
> > This one I guess:
> > http://bugzilla.kernel.org/attachment.cgi?id=18644&action=view
> >
> > Let me give it a shot, I'll keep you posted.
>
> So I compiled the module, rebooted just to have a clean starting point,
> started X then tried to suspend: no go...

Dave pushed a fix for this (more complete than the one in the patch you 
reference), have you tried the kernel from today to see if things work now?

Thanks,
Jesse


