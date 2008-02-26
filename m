Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbYBZV7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbYBZV7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932265AbYBZV7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:59:15 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:57309 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764580AbYBZV7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:59:13 -0500
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2/2] ib fmr pool: flush used clean entries
Date: Tue, 26 Feb 2008 22:58:25 +0100
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rdreier@cisco.com>, Pete Wyckoff <pw@osc.edu>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080225225330.GA3316@osc.edu> <20080226182753.GF7033@osc.edu> <adazltnwkbz.fsf@cisco.com>
In-Reply-To: <adazltnwkbz.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802262258.26536.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 21:09, Roland Dreier wrote:
> This looks like a really nice approach to me.  Olaf?

Yes, this looks good. I haven't had a chance to test it,
but it looks like the right approach.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
