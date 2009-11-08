Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbZKHPoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbZKHPoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZKHPoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:44:17 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:50174 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbZKHPoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:44:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=rXLmvbX/Bk6Xj+YoTTk5gOO7y+rMYEYDQ0lGwl6QASmlMJqSNyzKfnWcUSjB1Jl25U
         4K762EZCHSoPGFpHPv6CEEVWtRa5YfA2kzlNsQav2xY6bwqw26C0TyZKc8PCrlk+fLrR
         btqnft5XeHiSzUsWCQNEvPZJsx67jVohYRuL8=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH v2] rt2x00: Update copyright statements.
Date: Sun, 8 Nov 2009 16:44:14 +0100
User-Agent: KMail/1.9.10
Cc: Gertjan van Wingerde <gwingerde@gmail.com>, users@host1.serialmonkey.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1257692976-2036-1-git-send-email-gwingerde@gmail.com> <200911081622.07678.IvDoorn@gmail.com> <200911081626.28320.bzolnier@gmail.com>
In-Reply-To: <200911081626.28320.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911081644.15257.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 08 November 2009 16:22:07 Ivo van Doorn wrote:
> > On Sunday 08 November 2009, Gertjan van Wingerde wrote:
> > > As mentioned on the linux-wireless mailing list, the current copyright statements in the rt2x00 are
> > > meaningless, as the rt2x00 project is not even a formal legal entity. Therefore it is better to replace
> > > the existing copyright statements with copyright statements for the people that actually wrote the code.
> > > 
> > > Note: Updated to the best of my knowledge with respect to who contributed considerable amounts of code.
> > > 
> > > Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> > > CC: Ivo van Doorn <IvDoorn@gmail.com>
> > > CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > 
> > Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> NAK, stop trying to reverse the history.
> 
> Just replace rt2x00 claims with personal ones without moving
> "based on" around.

There is no need to get upset about this, I already said I would put the decision
in your hands. If you feel so strongly about this, then the original version should
be used, and the developers in question can move their copyright notice themselves
when they submit new patches.

Ivo
