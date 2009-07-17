Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbZGQVRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbZGQVRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 17:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbZGQVRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 17:17:05 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59348 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbZGQVRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 17:17:04 -0400
Date: Fri, 17 Jul 2009 23:17:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dick Streefland <dick@streefland.net>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: simplification of scripts/extract-ikconfig
Message-ID: <20090717211703.GF7080@merkur.ravnborg.org>
Mail-Followup-To: Dick Streefland <dick@streefland.net>,
	Amerigo Wang <xiyou.wangcong@gmail.com>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090623225245.GA10443@streefland.net> <20090624021506.GA5871@cr0.nay.redhat.com> <20090624114607.GA10817@streefland.net> <20090624133148.GA12878@streefland.net> <20090629025146.GA5998@cr0.nay.redhat.com> <20090629113613.GA6853@streefland.net> <20090709023855.GA5648@cr0.nay.redhat.com> <20090709082651.GA6165@streefland.net> <20090710075530.GB6263@cr0.nay.redhat.com> <20090710095432.GA9721@streefland.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710095432.GA9721@streefland.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 11:54:32AM +0200, Dick Streefland wrote:
> On Friday 2009-07-10 15:55, Amerigo Wang wrote:
> | Have you checked other version of grep? I mean lower version, of course,
> | does your script work with them too?
> 
> The script works with all grep versions since 2.5, released 2002-03-13,
> where the -o option was added. The config extraction feature was
> introduced in Linux 2.6.8, released 2004-08-14, so I don't think this
> dependency will be a problem.

Dick - I lost the original patch.
Can you please resend.

In the changelog please include the information that
you tested this with relevant grep versions.

	Sam
