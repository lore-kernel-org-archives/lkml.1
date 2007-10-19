Return-Path: <linux-kernel-owner+w=401wt.eu-S966968AbXJSJMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966968AbXJSJMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 05:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765838AbXJSJMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 05:12:14 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:2891 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765007AbXJSJMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 05:12:13 -0400
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2007 05:12:12 EDT
Date: Fri, 19 Oct 2007 09:55:55 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [bisected][mismerge?] Re: [microcode] 2.6.23.git pulled this morning oopses loading P4 microcode
Message-ID: <20071019085555.GB3809@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
References: <1192681533.7147.5.camel@Homer.simpson.net> <1192730198.7182.18.camel@Homer.simpson.net> <20071018223333.GD4153@implementation> <1192762138.6838.13.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192762138.6838.13.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-OriginalArrivalTime: 19 Oct 2007 08:55:57.0007 (UTC) FILETIME=[DCF71DF0:01C8122D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just to make sure, could you check in System.map that accent_table is
correctly 256*3*4=3072 bytes long?

Samuel
