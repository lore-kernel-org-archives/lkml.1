Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbXLVB5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbXLVB5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbXLVB5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:57:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46657 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbXLVB5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:57:03 -0500
Date: Sat, 22 Dec 2007 02:57:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, devzero@web.de,
       linux-kernel@vger.kernel.org, Matt.Domsch@dell.com
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
Message-ID: <20071222015758.GC4477@one.firstfloor.org>
References: <49015158@web.de> <47656B9E.3040405@zytor.com> <p73sl1vedhw.fsf@bingen.suse.de> <476C6D06.2070301@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476C6D06.2070301@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Those don't live in an area of memory which is hard-limited to 32K.

Why not 64k?

Ok, that's a different argument than before. Ok. Although it's
only a few bytes. 

I would lobby for any message at least contain the suggestion to try
edd=off. That could save users a lot of time.

-Andi
