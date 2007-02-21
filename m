Return-Path: <linux-kernel-owner+w=401wt.eu-S1423117AbXBUVE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423117AbXBUVE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423118AbXBUVE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:04:27 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:59902 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423117AbXBUVE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:04:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WmyndlrFfzxjEX8g9ubfmFBslV4VdLyLntHxfLWNPF19OYiofS8pNZimm9f9SPzq1GbTmDX/RLbpmV/B9Kzf2LUiGxwQQHvSxWGvy3M1280M3Lg5+1hV52AOF2WUo7R/thXv94Ksdr3/HkhetceYOFSRHXd7j/Dtx686V7owwEY=
Message-ID: <8d158e1f0702211304l6e718204n67e5045e7a98e08f@mail.gmail.com>
Date: Wed, 21 Feb 2007 22:04:24 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Vincent Legoll" <vincent.legoll@gmail.com>
Subject: Re: libsata doesn't like bus without master
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <8d158e1f0702211301n3d30f590t14b1501e418da7e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4727185d0702211241v63549a77ye1023e9ff802c24a@mail.gmail.com>
	 <4727185d0702211247r796a2f4fte8b9511aa6864452@mail.gmail.com>
	 <8d158e1f0702211301n3d30f590t14b1501e418da7e0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> On 2/21/07, Vincent Legoll <vincent.legoll@gmail.com> wrote:

>
> In the latter case it might explain why you see one master connected
> to one bus and a slave to the other. If you use legacy SATA mode you
> should just see drive 0 and drive 1.

Oh and! In case you use native SATA your harddisk will be driven by
the sata driver, and your CD-ROM driver by the pata driver, which in
case of piix is all the same driver so no worries there, but I thought
this would be nice to know information never the less :)

Patrick
