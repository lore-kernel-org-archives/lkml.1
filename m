Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYBXWSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYBXWSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 17:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYBXWSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 17:18:16 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843AbYBXWSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 17:18:15 -0500
Date: Sun, 24 Feb 2008 14:17:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric Van Hensbergen" <ericvh@gmail.com>
Cc: "Markus Armbruster" <armbru@redhat.com>, linux-kernel@vger.kernel.org,
       "Latchesar Ionkov" <lucho@ionkov.net>,
       "Jim Meyering" <meyering@redhat.com>
Subject: Re: [PATCH] Make v9fs uname and remotename parsing more robust
Message-Id: <20080224141733.91bd6a26.akpm@linux-foundation.org>
In-Reply-To: <a4e6962a0802240737q5ac061dbva766514055dbb72c@mail.gmail.com>
References: <87skzu5cmd.fsf@pike.pond.sub.org>
	<20080223000709.33a1c412.akpm@linux-foundation.org>
	<a4e6962a0802240737q5ac061dbva766514055dbb72c@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 09:37:23 -0600 "Eric Van Hensbergen" <ericvh@gmail.com> wrote:

> On Sat, Feb 23, 2008 at 2:07 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> >  It would be better to present this as two patches.  One adds the new core
> >  APIs and the other uses those APIs in v9fs.  The patches would take
> >  separate routes into mainline.
> >
> >  I guess I can sneak this one in as-is, as long as the v9fs guys are OK with
> >  that?
> >
> 
> I'm fine with it.  Shall I pull it through the v9fs-devel patch line
> or would you rather send it with your patches Andrew?
> 

It's more likely to get some testing in your tree, thanks.  I'll send over
my version with improved title and my s-o-b.
