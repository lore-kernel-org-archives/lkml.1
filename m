Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbXJYVoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbXJYVoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXJYVoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:44:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27990 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbXJYVn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:43:59 -0400
Date: Thu, 25 Oct 2007 14:43:41 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Joel Becker <joel.becker@oracle.com>, kurt.hackel@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make ocfs2_find_entry_el() static
Message-ID: <20071025214341.GU28607@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20071024162327.GP30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024162327.GP30533@stusta.de>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 06:23:27PM +0200, Adrian Bunk wrote:
> ocfs2_find_entry_el() can become static.

Looks good, thanks Adrian.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
