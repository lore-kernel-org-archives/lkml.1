Return-Path: <linux-kernel-owner+w=401wt.eu-S1761700AbYAVJ7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761700AbYAVJ7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbYAVJ7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:59:39 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36370 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbYAVJ7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:59:38 -0500
Message-ID: <4795BE87.3060809@garzik.org>
Date: Tue, 22 Jan 2008 04:59:35 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: jacliburn@bellsouth.net
CC: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net
Subject: Re: [PATCH 13/26] atl1: refactor interrupt handling
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net> <1199152804-3889-14-git-send-email-jacliburn@bellsouth.net>
In-Reply-To: <1199152804-3889-14-git-send-email-jacliburn@bellsouth.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jacliburn@bellsouth.net wrote:
> From: Jay Cliburn <jacliburn@bellsouth.net>
> 
> Refactor interrupt handling to conform with the current vendor driver
> version 1.2.40.2.
> 
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> ---
>  drivers/net/atlx/atl1.c |  196 ++++++++++++++++++++++-------------------------
>  drivers/net/atlx/atl1.h |   25 +++++-
>  drivers/net/atlx/atlx.c |    2 +-
>  3 files changed, 114 insertions(+), 109 deletions(-)

same comments... "refactor" should be explained further in the changelog

