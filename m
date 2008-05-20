Return-Path: <linux-kernel-owner+w=401wt.eu-S934360AbYETWUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360AbYETWUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761333AbYETWT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:19:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43694
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760090AbYETWT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:19:57 -0400
Date: Tue, 20 May 2008 15:19:51 -0700 (PDT)
Message-Id: <20080520.151951.239145609.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] byteorder: eliminate pointer bytorder api
From: David Miller <davem@davemloft.net>
In-Reply-To: <1211321725.5915.208.camel@brick>
References: <1211311449.5915.195.camel@brick>
	<20080520.141731.99514303.davem@davemloft.net>
	<1211321725.5915.208.camel@brick>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Tue, 20 May 2008 15:15:25 -0700

> Obviously I missed that part, my apologies.  Would it be acceptable if,
> taking the possibly arch-specific parts, moved the [endian]_to_cpup
> name over to get_[endian]

Why are we fiddling with interface names that have been fine for about
10 years?
