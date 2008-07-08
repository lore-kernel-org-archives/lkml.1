Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbYGHOhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbYGHOhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 10:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYGHOhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 10:37:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:4436 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYGHOhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 10:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d7MB4mo9MqzCXwB7OeNuSmued1f2AW0VhunGgZ90zH4rRQzXuCHuqnOhw46Id6jfDW
         JZS17abd4YBYlVYc0b0T747h2voMHRK0O1H0l4lGX2GubPeSsgmRl5a3J6PXBoDD2IvO
         wPREElYc+XngFsi6hr8ADGiCEI4Q0H3Ru47nU=
Date: Tue, 8 Jul 2008 10:37:32 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serio.h: trivial documentation fix
Message-ID: <20080708143731.GA8560@USFSHXP-002051>
References: <48733119.5080502@wincor-nixdorf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48733119.5080502@wincor-nixdorf.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 11:19:21AM +0200, Niels de Vos wrote:
> In include/linux/serio.h two different define-series are
> documented as "Serio types". However the second series contains
> defines for the different protocols.
>

Applied, thank you Niels.

BTW, your e-mail client mangles whitespace which causes trouble
when applying patches, you may want to look into it.

-- 
Dmitry
