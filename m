Return-Path: <linux-kernel-owner+w=401wt.eu-S1762817AbYBRVF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817AbYBRVF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762233AbYBRVEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:04:00 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:12088 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762229AbYBRVD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:03:59 -0500
Date: Mon, 18 Feb 2008 13:03:37 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make ocfs2_downconvert_thread() static
Message-ID: <20080218210337.GC22671@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20080217082038.GU3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217082038.GU3848@cs181133002.pp.htv.fi>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 10:20:38AM +0200, Adrian Bunk wrote:
> This patch makes the needlessly global ocfs2_downconvert_thread() 
> static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks, this is in ocfs2.git now.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
