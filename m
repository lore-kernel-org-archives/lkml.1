Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbYEHSIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbYEHSIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYEHSIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:08:41 -0400
Received: from main.gmane.org ([80.91.229.2]:54804 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYEHSIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:08:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: 2.6.26-git: ata_piix link is slow to respond regression.
Date: Thu, 8 May 2008 18:08:19 +0000 (UTC)
Message-ID: <fvvfij$u94$1@ger.gmane.org>
References: <1210267842.4175.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Cc: linux-ide@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2008 19:30:42 +0200, Soeren Sonnenburg wrote:

> ata_piix 0000:00:1f.2 MAP [P0 P2 -- -- ] link is slow to respond, please
> be patient ﻿(ready=0) SRST failed ﻿(errno=-1f)

The issue might be solved by the patch on 
http://thread.gmane.org/gmane.linux.ide/31317/focus=31349 ...

-- 
Sitsofe | http://sucs.org/~sits/

