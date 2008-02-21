Return-Path: <linux-kernel-owner+w=401wt.eu-S932482AbYBUVWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbYBUVWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYBUVVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:21:54 -0500
Received: from qb-out-0506.google.com ([72.14.204.225]:61348 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYBUVVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:21:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=h9ftcsciKOi4E/gljd8irmIw5QFwWOJ3vU8CAoeP7w57TAPVxeQrOz+bgYG3VeA/e7j63fuUsmOh0W0lQphd6XaWo4S+ej+c4UfIzCpvDCR6JDWyplEL1QPW5N0/WCM5k1ATPnqkYOdlumK2Pi3/gMRF4tFDPON0GDuBW4MUQqQ=
Subject: Re: [PATCH] saa7146: fix sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080221211927.GB27894@ZenIV.linux.org.uk>
References: <1203616356.20345.45.camel@brick>
	 <20080221211927.GB27894@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 13:22:06 -0800
Message-Id: <1203628926.20345.73.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 21:19 +0000, Al Viro wrote:
> On Thu, Feb 21, 2008 at 09:52:36AM -0800, Harvey Harrison wrote:
> 
> Could you please use more descriptive names?  NULL noise removal
> is not the same as shadowing or endianness annotations or endianness
> fixes or __user/__iomem annotations/fixes, etc.

Point taken, will do so going forward.

For now, I'm just doing the trivial ones to make the more interesting
warnings stand out a little better.

Harvey

