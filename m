Return-Path: <linux-kernel-owner+w=401wt.eu-S934410AbXLTSAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934410AbXLTSAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbXLTSA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:00:26 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:44448 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbXLTSAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:00:25 -0500
Date: Thu, 20 Dec 2007 09:59:50 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Handle i_size > s_maxbytes correctly
Message-ID: <20071220175950.GI13821@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20071220175104.GA11911@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220175104.GA11911@duck.suse.cz>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 06:51:04PM +0100, Jan Kara wrote:
>   Hi Andrew,
> 
>   nobody seemed to care about this patch, so could you pull it into -mm so
> that it gets broader testing? Thanks.

Oh, this can get my ack btw:

Acked-by: Mark Fasheh <mark.fasheh@oracle.com>
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
