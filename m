Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751670AbYLQSfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbYLQSfo (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYLQSfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:35:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58384 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbYLQSfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:35:34 -0500
Subject: Re: [PATCHSET] audit patches for .29-rc1
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <E1LCogW-000088-SO@ZenIV.linux.org.uk>
References: <E1LCogW-000088-SO@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 13:35:29 -0500
Message-Id: <1229538929.3384.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 05:11 +0000, Al Viro wrote:
> The following patch series is intended for the next merge cycle; review
> and testing would be welcome.  It seems to survive light beating here...
> 
> It can also be found in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b60

You can add my Acked-by or Reviewed-by to all of them except "fixing
audit rule ordering mess, part 1" if you can't find anything better to
do with your time....

-Eric


