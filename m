Return-Path: <linux-kernel-owner+w=401wt.eu-S2992885AbXDDND5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992885AbXDDND5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 09:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992894AbXDDND5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 09:03:57 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:58363 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992885AbXDDND4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 09:03:56 -0400
Message-ID: <4613A1F1.2080007@gmail.com>
Date: Wed, 04 Apr 2007 15:02:41 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <46138B4C.2050409@gmail.com> <20070404123311.GA18552@infradead.org>
In-Reply-To: <20070404123311.GA18552@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2007 02:33 PM, Christoph Hellwig wrote:

> On Wed, Apr 04, 2007 at 01:26:04PM +0200, Rene Herman wrote:

>> Can we have a MODULE_MAINTAINER to complement MODULE_AUTHOR?
> 
> #define MODULE_MAINTAINER(x) MODULE_AUTHOR(x), please.
> MODULE_AUTHOR really has meant maintainer in practice for ages, and it's
> the only actually relevant for users information we should store.

Given modules with multiple authors, current and non-current, I believe 
having "modinfo -m" tell the user whom to contact is an avantage.

Rene.
