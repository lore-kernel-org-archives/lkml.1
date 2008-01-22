Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYAVUBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYAVUBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYAVUBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:01:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:11052 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYAVUBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:01:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oPXb7Pvu6lQA1bPEoa2InBvQGreQRVzWaRGh7h8lXpRFsoBv2rshePyR+Xv8QZYHW7M9LmiWVuejorIwXw3d2bW2Rf4n4WXHBMNdpBVXWvFaLtaHhHrUdoJzAnbgBNsLUTFr9uQEJkqnvy/EyX2g1Wa3Xh2tZ6WXeXLYSw0dIhM=
Message-ID: <38b2ab8a0801221201r19ab66aau623daf8c183d9ac2@mail.gmail.com>
Date: Tue, 22 Jan 2008 21:01:28 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: Linux and remote control device
Cc: vojtech@suse.cz, linux-kernel@vger.kernel.org
In-Reply-To: <479644DB.6010807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0801220001t284c41bdo42b534599249df2a@mail.gmail.com>
	 <479644DB.6010807@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 22, 2008 8:32 PM, Chuck Ebbert <cebbert@redhat.com> wrote:
> On 01/22/2008 03:01 AM, Francis Moreau wrote:
> > Hello,
> >
> > I'd like to add support for my Infrared remote control to Linux.
> >
> > So far I only see LIRCD project that make the kernel support
> > such device but I'm not sure if this project is the best choice
> > since it's not part of mainline kernels. And there are certainly
> > good reasons which I'm not aware of.
> >
>
> lirc is being worked on and is nearly ready for upstream submission.
>

Really ?

I'm wondering why lirc doesn't use the input subsystem, do you have any ideas ?

-- 
Francis
