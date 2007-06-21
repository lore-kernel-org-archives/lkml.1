Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbXFUAWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbXFUAWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 20:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbXFUAVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 20:21:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17085 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbXFUAVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 20:21:52 -0400
Date: Wed, 20 Jun 2007 17:21:16 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       ocfs2-devel@oss.oracle.com, cluster-devel@redhat.com,
       samba-technical@lists.samba.org,
       ext4 development <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] zero_user_page conversion
Message-ID: <20070621002116.GB17713@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <4679A558.1010107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4679A558.1010107@redhat.com>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 05:08:24PM -0500, Eric Sandeen wrote:
> Use zero_user_page() in cifs, ocfs2, ext4, and gfs2 where possible.

Ok, the ocfs2 bits looked fine so I folded that part of the patch into
ocfs2.git, thanks.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
