Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZA0PZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZA0PZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZA0PZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:25:19 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:29507 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbZA0PZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:25:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=SKV5aKyOOlEz3l292Cc+J4xOqDC2ylpLKhANXrxcpLI5sO/gPLgq/LJmgQoc8GjFfY
         SHog56/ahXKAjeB/jJl6TN3GOZnjacewf0uifO1A7AF/0oseByJlib+D7GFR69zd/jr1
         He57OKR3HLzbiHYBofMEqS2MxrDCZLm1RiY5U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 2/3] ide: improve debugging scheme
Date: Tue, 27 Jan 2009 16:22:47 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090126; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1233002440-4325-1-git-send-email-petkovbb@gmail.com> <1233002440-4325-2-git-send-email-petkovbb@gmail.com> <20090127061906.GA22179@gollum.tnic>
In-Reply-To: <20090127061906.GA22179@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271622.47400.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2009, Borislav Petkov wrote:
> On Mon, Jan 26, 2009 at 09:40:39PM +0100, Borislav Petkov wrote:
> > and more specifically, push __func__ into debug
> > macro thus making ide_debug_log() calls shorter and more readable.
> 
> Ups, sorry, I left the debug on :). Take better that one instead.
> 
> ---
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Fri, 2 Jan 2009 13:34:47 +0100
> Subject: [PATCH 2/3] ide: improve debugging scheme
> 
> and more specifically, push __func__ into debug
> macro thus making ide_debug_log() calls shorter and more readable.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
