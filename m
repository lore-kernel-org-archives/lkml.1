Return-Path: <linux-kernel-owner+w=401wt.eu-S1764632AbXGaPO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764632AbXGaPO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760980AbXGaPOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:14:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758280AbXGaPOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:14:18 -0400
Date: Tue, 31 Jul 2007 11:14:15 -0400
From: Dave Jones <davej@redhat.com>
To: "Brian D. McGrew" <brian@visionpro.com>
Cc: fedora-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: SATA CD Support
Message-ID: <20070731151415.GE5966@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Brian D. McGrew" <brian@visionpro.com>, fedora-list@redhat.com,
	linux-kernel@vger.kernel.org
References: <14CFC56C96D8554AA0B8969DB825FEA0037FAEF8@chicken.machinevisionproducts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14CFC56C96D8554AA0B8969DB825FEA0037FAEF8@chicken.machinevisionproducts.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 07:03:21AM -0700, Brian D. McGrew wrote:
 > On my FC5 box with the stock 2.6.15 kernel the system works with SATA
 > CD's.
 > 
 > When I put my own 2.6.16.16 kernel in the SATA CD's do not work.  What
 > could I have missed in the configuration options???

iirc, the upstream kernel didn't support ATAPI over SATA until 2.6.18
The FC5 kernel was patched to make it work.

	Dave

-- 
http://www.codemonkey.org.uk
