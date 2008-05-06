Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbYEFHki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbYEFHki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 03:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYEFHk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 03:40:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:27127 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYEFHkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 03:40:25 -0400
Subject: Re: 2.6.26-rc1-git1 -- trying to get vblank count for disabled
	pipe 0
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@tungstengraphics.com>
To: Steven J Newbury <steve@snewbury.org.uk>
Cc: Miles Lane <miles.lane@gmail.com>, David Airlie <airlied@linux.ie>,
       DRI for Linux <dri-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209991916.24777.8.camel@infinity>
References: <481E5EE6.6090503@gmail.com>
	 <1209975302.26326.263.camel@thor.sulgenrain.local>
	 <1209991916.24777.8.camel@infinity>
Content-Type: text/plain; charset=utf-8
Organization: Tungsten Graphics
Date: Tue, 06 May 2008 09:40:19 +0200
Message-Id: <1210059619.26326.354.camel@thor.sulgenrain.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-05 at 13:51 +0100, Steven J Newbury wrote:
> 
> I'm also getting occasional lockups.  Often it's the window manager
> (metacity) that locks up when attempting to move a window, restarting
> the window manager unlocks X but attempting to move a window again
> results in another lockup.  When it's locked up the pointer moves and vt
> switching works but nothing else.  

That sounds like an input related X server bug, probably not related to
the original problem.


-- 
Earthling Michel Dänzer           |          http://tungstengraphics.com
Libre software enthusiast         |          Debian, X and DRI developer

