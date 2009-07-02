Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbZGBRVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbZGBRVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbZGBRVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:21:45 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:35550 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbZGBRVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:21:44 -0400
Date: Fri, 3 Jul 2009 02:21:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dev@uclinux.org
Subject: Re: [PATCH] FLAT: use IS_ERR_VALUE() helper macro
Message-ID: <20090702172141.GB3951@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org,
	David Howells <dhowells@redhat.com>,
	David McCullough <davidm@snapgear.com>,
	Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org
References: <1246472802-15824-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246472802-15824-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 02:26:42PM -0400, Mike Frysinger wrote:
> There is a common macro now for testing mixed pointer/errno values, so use
> that rather than handling the casts ourself.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: Paul Mundt <lethal@linux-sh.org>
