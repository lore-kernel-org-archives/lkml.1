Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZGCJ7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZGCJ7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbZGCJ7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:59:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbZGCJ7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:59:32 -0400
Date: Fri, 3 Jul 2009 11:59:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: adding __init/__exit macros to several hids
In-Reply-To: <200907021908.39275.PeterHuewe@gmx.de>
Message-ID: <alpine.LNX.2.00.0907031159210.4994@wotan.suse.de>
References: <200907021908.39275.PeterHuewe@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-624173346-1246615174=:4994"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-624173346-1246615174=:4994
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 2 Jul 2009, Peter Hüwe wrote:

> Trivial patch which adds the __init and __exit macros to the module_init /
> module_exit functions of several hids from drivers/hid/

Applied, thanks Peter.

-- 
Jiri Kosina
SUSE Labs
--168427776-624173346-1246615174=:4994--
