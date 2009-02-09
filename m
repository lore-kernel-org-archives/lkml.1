Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZBII64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZBII64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZBII6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:58:48 -0500
Received: from adelie.canonical.com ([91.189.90.139]:58958 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZBII6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:58:47 -0500
Date: Mon, 9 Feb 2009 08:58:45 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl is getting too slow
Message-ID: <20090209085845.GC32740@shadowen.org>
References: <20090131185507.GA3280@kroah.com> <20090131210220.GA25811@shadowen.org> <1233449877.5903.48.camel@desktop> <20090201044614.GA8589@kroah.com> <1233510446.5903.87.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233510446.5903.87.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 01, 2009 at 09:47:26AM -0800, Daniel Walker wrote:

> This fixes the sanitation process in checkpatch.pl so that it blocks out
> the text after a C99 style comment the same way it does with block style
> comments. This prevents the text from getting processed as regular code.
> 
> Signed-off-by: Daniel Walker <dwalker@fifo99.com>

Yeah this patch seems good.  I have applied the patch to my tree and it
passes all the tests.  Thanks for finding it.

-apw
