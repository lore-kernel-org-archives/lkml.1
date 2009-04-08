Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbZDHFb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbZDHFb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZDHFbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:31:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:12748 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZDHFbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:31:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gbliqg6TToPVgZlcA/akQOmVuUS0ge3+UO3/FqSlCqM6DATeie21bI4CjpNREKZ7lb
         WYNHYu7vKSXN2nQmcnBKJooaII6R94Cv9he7fV2RgzMYPfoVTFL+lVQXwIgiiorR850b
         zhKD9f2041UXyDirDmXY/d7EUafc5wjRSvP48=
MIME-Version: 1.0
In-Reply-To: <49DC3357.3030703@garzik.org>
References: <20090407232247.GA16086@havoc.gtf.org>
	 <20090407232331.GA16190@havoc.gtf.org>
	 <3fb94e50904072213n637525b1w4b032544dcef3618@mail.gmail.com>
	 <49DC3357.3030703@garzik.org>
Date: Wed, 8 Apr 2009 11:01:44 +0530
Message-ID: <3fb94e50904072231o71224227t340760518ebe76b8@mail.gmail.com>
Subject: Re: [PATCH 2/2] sata_sil: disable DMA engine in ->freeze
From: Sagar Borikar <sagar.borikar@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, d.harrison@sutus.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes!

Thanks again

Sagar

On Wed, Apr 8, 2009 at 10:47 AM, Jeff Garzik <jeff@garzik.org> wrote:
> Sagar Borikar wrote:
>>
>> This patch works for our platform.
>
> Did you try both patches together?  Both are required for the solution.
>
>        Jeff
>
>
>
>
