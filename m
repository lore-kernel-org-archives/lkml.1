Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbZHAK4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbZHAK4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 06:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZHAK4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 06:56:15 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:52781 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbZHAK4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 06:56:14 -0400
From: Frans Pop <elendil@planet.nl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH v2] Remove Spurious PnP Memory Reserved Warning
Date: Sat, 1 Aug 2009 12:56:10 +0200
User-Agent: KMail/1.9.9
Cc: David John <davidjon@xenontk.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, yinghai@kernel.org
References: <1248505976-4952-1-BlackWidow-davidjon@xenontk.org> <1248753983-4334-1-BlackWidow-davidjon@xenontk.org> <20090728093137.52575d8c@jbarnes-g45>
In-Reply-To: <20090728093137.52575d8c@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908011256.11628.elendil@planet.nl>
X-OriginalArrivalTime: 01 Aug 2009 10:56:12.0108 (UTC) FILETIME=[AED528C0:01CA1296]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 July 2009, Jesse Barnes wrote:
> I'm inclined to keep the message, since it's just a dev_info and does
> provide interesting info sometimes.  So unless Linus wants to kill
> it...

Jesse, what do you think of the less invasive patch I suggested in 
http://lkml.org/lkml/2009/7/24/16?

Cheers,
FJP
