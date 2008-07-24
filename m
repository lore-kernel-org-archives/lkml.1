Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbYGXUTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbYGXUTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYGXUT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:19:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:10207 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbYGXUT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:19:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=NZpFKPMLgypGpMeFZAZLmx5cncYGN225ZAzeuYpkw7ZhEcmjwIgTGSgVzMGTslosJ7
         +cWWzM/i4qqzFYAczxMBu+PmC6svRI5Z8OfKRmS9yn5aOURHvRgGHhAxgcN3TJDG5nEC
         3SEh98mgw7r0LWo0F//ATBkfu6z3c3gKvDeWE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 3/4] isd200: use ATA_* defines instead of *_STAT and *_ERR ones
Date: Thu, 24 Jul 2008 22:16:59 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200807242123.42923.bzolnier@gmail.com> <20080724195722.GA9859@suse.de>
In-Reply-To: <20080724195722.GA9859@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807242216.59516.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008, Greg KH wrote:
> On Thu, Jul 24, 2008 at 09:23:42PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Thanks, please also take a look at previous isd200 patches
when you have some time:

http://lkml.org/lkml/2008/7/23/213
http://lkml.org/lkml/2008/7/23/197

[ they should also be in your overflowed inbox :) ]
