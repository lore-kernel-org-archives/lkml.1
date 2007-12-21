Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbXLUWEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbXLUWEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbXLUWEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:04:06 -0500
Received: from emroute3.ornl.gov ([160.91.4.110]:45388 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbXLUWED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:04:03 -0500
X-Greylist: delayed 665 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2007 17:04:00 EST
Date: Fri, 21 Dec 2007 16:54:49 -0500
From: David Dillow <dillowda@ornl.gov>
Subject: Re: list corruption on ib_srp load in v2.6.24-rc5
In-reply-to: <1198273973.9979.34.camel@lap75545.ornl.gov>
To: linux-kernel@vger.kernel.org
Cc: general@lists.openfabrics.org
Message-id: <1198274089.9979.35.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <1198273973.9979.34.camel@lap75545.ornl.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-21 at 16:52 -0500, David Dillow wrote:
> Before I get too far into this, has anyone seen this one before? I
> looked at 'git diff v2.6.24-rc4..' and didn't see any changes that would
> stand out as fixing it.

This should read v2.6.24-rc5...

