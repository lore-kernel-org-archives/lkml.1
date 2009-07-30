Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbZG3Rft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbZG3Rft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbZG3Rft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:35:49 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:48252 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZG3Rfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:35:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=NEJH3LcQghIq00dlPF4Mai+IePWNr2f+0TPhqVj07OkEJdEKvmnzhKePF99KQEw5vz
         3TGnMAtmoGFvZsV7ltEVrTQKXiU8sh7yka2aUAtFJY9Vn/SfdOEZURbFVm+lt233w2Qv
         cATErp9QSWUBbx8ykZB3f+KXvcDBwy2rRKx1Y=
Date: Thu, 30 Jul 2009 10:35:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: TJ <linux@tjworld.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Bug 346586 <346586@bugs.launchpad.net>
Subject: Re: wistron_btns: support Prestigio Wifi RF kill button over
	suspend
References: <1248939530.3410.10.camel@hephaestion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248939530.3410.10.camel@hephaestion>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090730180947.6B391526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 30, 2009 at 08:38:50AM +0100, TJ wrote:
> We've been carrying this patch in Ubuntu since March 2009. I emailed the
> upstream maintainer prior to that but there was no reply or action so it
> hasn't been pushed upstream as I had expected.
> 
> https://launchpad.net/bugs/346586
> 
> I wonder if the maintainer field for this module should be changed to
> reflect that?
> 
> ----
> 
> The Prestigio 157, an old no-name clone laptop uses input keys very
> similar to the Wistron 1557/MS2141 with the addition of BIOS-controlled
> wireless radio frequency kill switch.
> 
> This patch adds support for the RF kill switch control and adds manual
> identification of the model.
> 
> The Prestigio does not expose any recognisable identity via dmidecode
> and so requires manual selection at module init using
> 
> force=1 keymap=prestigio
> 
> Signed-off-by: TJ <ubuntu@tjworld.net>
> 

I'd like to pick up this patch but you really need to use your name instead
of just initials in your signoff line. Care to resend, please?

Thanks!

-- 
Dmitry
