Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZI0IlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZI0IlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbZI0IlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:41:10 -0400
Received: from [195.41.46.236] ([195.41.46.236]:56781 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbZI0IlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:41:07 -0400
Date: Sun, 27 Sep 2009 10:41:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH v2 2/6] kbuild: fix warning when domainname is not
	available
Message-ID: <20090927084105.GC10177@merkur.ravnborg.org>
References: <1253137123-18047-1-git-send-email-felipe.contreras@gmail.com> <1253137123-18047-2-git-send-email-felipe.contreras@gmail.com> <1253137123-18047-3-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253137123-18047-3-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 12:38:39AM +0300, Felipe Contreras wrote:
> Otherwise we get:
> "dnsdomainname: Unknown host"
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

Thanks for the respin.
Applied both patches.

	Sam
