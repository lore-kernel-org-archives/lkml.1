Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbYDHGxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbYDHGxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 02:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYDHGxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 02:53:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:58095 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYDHGxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 02:53:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gOa5FZBentEIS9wzjYVIrjAzGlVaJIBhx+NTN9m/muESiV1tOtQ98nYg94JqNQCzyyb+FaNjIUbuTvXTDl2g0y2xEtQZxEZgVA2B5l3WP1NRXvle27KWWI9R0kWG3TNnY0sx5Sazn8IVnNn35pQ11C7zQc9VtmMbcPchtiB3tzM=
Message-ID: <544ab8580804072353p3d4442e4yd94c511491527eee@mail.gmail.com>
Date: Tue, 8 Apr 2008 08:53:35 +0200
From: "=?ISO-8859-1?Q?K=E1roly_Kasza?=" <kaszak@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: w35und: more cleanups
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>, lcostantino@gmail.com
In-Reply-To: <20080407194611.GA8547@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080407192812.GA18868@elf.ucw.cz>
	 <20080407194611.GA8547@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nope, we are planning to rewrite it, Pavel is cleaning it up for
easirer study. For its origin see http://lkml.org/lkml/2007/10/21/116.

On Mon, Apr 7, 2008 at 9:46 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Apr 07, 2008 at 09:28:12PM +0200, Pavel Machek wrote:
>  > Next set of cleanups to bring kernel closer to kernel coding style...
>
>  \Where is that driver coming from to start with?  I hope no one intends
>  to send it to mainline in a shape like that?
>  >
>
