Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYJHT3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYJHT3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbYJHT3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:29:00 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:20098 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbYJHT27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:28:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=B9QSOrYJ7ibsmQ0j1G98AagF4cmnhKhHRmyaPQW1MlAiwJe34cgDGxTNVh/OzJ0Et0
         IJGWcbyzNjS9DObw1wohvYzQ4sS4OmXpk7bqHWdGoMlvPu5jyk3kftxCAbc6Efvx7wl5
         T78z5rCT23xMiJRA3U3X55b303ZUHvF8bD9zg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH 4/4 v2] Add documentation for hard disk shock protection interface
Date: Wed, 8 Oct 2008 20:56:37 +0200
User-Agent: KMail/1.9.10
Cc: "Grant Grundler" <grundler@google.com>, Jeff Garzik <jeff@garzik.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <htejun@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <87d4j2n3dn.fsf@denkblock.local> <200809181628.34569.bzolnier@gmail.com> <8763o8znuf.fsf@denkblock.local>
In-Reply-To: <8763o8znuf.fsf@denkblock.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810082056.37215.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 October 2008, Elias Oltmanns wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > On Wednesday 17 September 2008 09:40:06 Elias Oltmanns wrote:
> >> Put some information (and pointers to more) into the kernel's doc tree,
> >
> >> describing briefly the interface to the kernel's disk head unloading
> >> facility. Information about how to set up a complete shock protection
> >> system under GNU/Linux can be found on the web and is referenced
> >> accordingly.
> >> 
> >> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> >
> > applied
> 
> Here is some final polish including various spelling corrections
> pointed out by Grant Grundler and Peter Moulder. Also, I have added some
> information about the timing constraints related to disk head parking.
> The patch looks more impressive than it really is and I think it would
> be alright just to incorporate it into the original patch so as not to
> clutter up the git log.
> 
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>

merged into the original patch
