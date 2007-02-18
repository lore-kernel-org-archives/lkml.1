Return-Path: <linux-kernel-owner+w=401wt.eu-S1161106AbXBRICs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161106AbXBRICs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 03:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161107AbXBRICs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 03:02:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:18304 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161106AbXBRICr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 03:02:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=UHWj3PI5FN2UP9Majq8o8ohlMKVe2f4zy4KCQ9KytepxfOARRifelVNU2wlhV+n8bm4BVWJFs4MUzWG7Yu1vQVAs0kvE/cr8Zul98m2zOyMpt4gHkRY1GdJqhnJqvKfb/rptLc/9InLmRpWKd8EnydAHo63ddjqM/Kvwc3si9gE=
Date: Sun, 18 Feb 2007 11:00:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dan Aloni <da-x@monatomic.org>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: e2b2rom_init_one():  Unable to register resource
Message-ID: <20070218080005.GB10865@cvg>
References: <20070217212918.GA26554@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217212918.GA26554@localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No, that's portability bug... Need time for review ;)

		Cyrill

