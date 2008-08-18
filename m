Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbYHRRrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbYHRRrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbYHRRrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:47:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:28288 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYHRRrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ulB3UVVOKSq7UpBbEMqDQiVYunwrqvGzaVIb6YZy8Wl9a5YVmi0ayIkiqoDQz6U/DA
         bOgwqvC8AVXdk6NvNqqmBzLfjf1LhdFobseaek3CZlEMJWU7i2eZb0AE1inoOZsuAIlz
         IoZ1u8fojhZpAnLV9Nbjdw8iMqgzjx/Y6WJSg=
Date: Mon, 18 Aug 2008 13:47:27 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Alfred E. Heggestad" <aeh@db.org>
Cc: Oliver Neukum <oliver@neukum.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset #2
Message-ID: <20080818134407.ZZRA012@mailhub.coreip.homeip.net>
References: <200806271424.50425.oliver@neukum.org> <200808041356.57928.oliver@neukum.org> <489767D3.6070408@db.org> <200808050008.48846.oliver@neukum.org> <4898A8C2.2080307@db.org> <20080805201403.GA13557@anvil.corenet.prv> <4898C3D8.4010004@db.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4898C3D8.4010004@db.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alfred,

On Tue, Aug 05, 2008 at 11:19:20PM +0200, Alfred E. Heggestad wrote:
>
> I send a new complete CM109 patch below, hope things are working better
> this time.. your input has been appreciated!
>

I reworked support for sepcial keys so they can also be set via
setkeycode and dropped the keymap for carpophone since is was marked
as incomplete. The driver is in the 'next' branch of my tree and will
be merged when 2.6.28 opens.

Thank you for your patience.

-- 
Dmitry
