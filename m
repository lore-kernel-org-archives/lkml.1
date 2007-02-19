Return-Path: <linux-kernel-owner+w=401wt.eu-S932380AbXBSQBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbXBSQBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 11:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932384AbXBSQBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 11:01:16 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:58672 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbXBSQBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 11:01:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rUIzdKblg0MC0PMD3+WpL76nMRTLd22JMLuTwjVcYoIoClrqFadaNvqHasv7l4cXgB+PDk+JJ7/qdcBZLw/WISuZ3rqMApH0mkxfef35XaHdikkjWA2++kWCxoCzYT0xaTOoilScmXAXXgawFu8sFp44YAv4BL3vXAHYssa4gNo=
Date: Mon, 19 Feb 2007 18:58:29 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dan Aloni <da-x@monatomic.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: e2b2rom_init_one():  Unable to register resource
Message-ID: <20070219155829.GA10111@cvg>
References: <20070217212918.GA26554@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217212918.GA26554@localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan

did you try setup forsed 8MB value on window->phys?

		Cyrill

