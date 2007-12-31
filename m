Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbXLaThL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbXLaThL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 14:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXLaTg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 14:36:58 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:64685 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXLaTg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 14:36:57 -0500
Date: Mon, 31 Dec 2007 11:35:42 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ocfs2: convert byte order of constant instead of
	variable
Message-ID: <20071231193542.GR13821@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20071225145256.GD24373@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071225145256.GD24373@joi>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2007 at 03:52:59PM +0100, Marcin Slusarz wrote:
> convert byte order of constant instead of variable
> it will be done at compile time (vs run time)
> remove unused le32_and_cpu

Ok, this looks good. I'll put it in ocfs2.git later today.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
