Return-Path: <linux-kernel-owner+w=401wt.eu-S1762339AbYG3ORz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762339AbYG3ORz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbYG3ORn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:17:43 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56616 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYG3ORn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:17:43 -0400
Subject: Re: [PATCH 4/7] nsc-ircc: Default to dongle type 9 on IBM hardware
From: Ben Collins <ben.collins@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <samuel@sortiz.org>
In-Reply-To: <20080730051110.GA26671@srcf.ucam.org>
References: <E1KKl4I-00068K-V7@swissweb.swissdisk.com>
	 <1216618176.8411.124.camel@violet.holtmann.net>
	 <1216662057.7585.153.camel@cunning>
	 <20080728194612.01068283.akpm@linux-foundation.org>
	 <20080730014439.GA24409@srcf.ucam.org>
	 <20080729191614.b8ee5fe8.akpm@linux-foundation.org>
	 <20080730051110.GA26671@srcf.ucam.org>
Content-Type: text/plain
Organization: Canonical
Date: Wed, 30 Jul 2008 10:17:38 -0400
Message-Id: <1217427458.5976.102.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 06:11 +0100, Matthew Garrett wrote:
> On Tue, Jul 29, 2008 at 07:16:14PM -0700, Andrew Morton wrote:
> 
> > We're getting there.  Who actually authored the patch?
> 
> Me. I can resend with a new description if you'd like.

Matthew did the original patch, I just reworked it based on some
comments.

