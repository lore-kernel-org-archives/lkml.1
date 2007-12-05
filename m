Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbXLEQvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbXLEQvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXLEQvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:51:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:7720 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXLEQvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:51:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hPb4/mrZ32OLbtRy8k+qjj9EQAd6eNNVXMelmv8z1Ryqk1fDsiyUBrEBZ1hnXi5UhRKGikmsQ4+ytYxCmH6W0ncCaJBwQNASY38ZEpRzwJnrFnaQMNSpNUvjxRHOB3KiYdY0d0Sn3VSY8n2jdHpMXlwEHzn+Wzt/E/SH3Ac5k6c=
Message-ID: <a372714f0712050851t4f20ac06nd86fa0ac747c427f@mail.gmail.com>
Date: Wed, 5 Dec 2007 08:51:36 -0800
From: "Brett Warden" <brett.warden@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] bw-qcam: Adds module parameter 'aggressive' to skip polite auto-detection prior to direct initialization.
In-Reply-To: <a372714f0712050849x6247f464p86be8598cbf5990b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071205004639.3a5cc948@the-village.bc.nu>
	 <a372714f0712050849x6247f464p86be8598cbf5990b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, forgot to copy back to the lists.

On Dec 5, 2007 8:49 AM, Brett Warden <brett.warden@gmail.com> wrote:
> On Dec 4, 2007 4:46 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> > Someone still has a bw-qcam device ?
>
> Yes. I haven't found a better option for very-low-light, although I
> admit I haven't looked in a long while. The last one I tried was an
> OV518+, but of course that driver seems to have been abandoned.
>
> > The status polling ought to be rock solid - what values do you see ?
>
> It has been as high as 94-96, but after being connected, powered, and
> used for a while, it drops sometimes into the 40s, but has even been
> as low as 8-14. When it's that low, it never comes back up until
> either I disconnect/reconnect the power, or I force the driver to
> initialize it through this hack. Even after trying that again just
> now, it's ranging from 24-33.
>
> --
> Brett Warden
>



-- 
Brett Warden
