Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbXLUOLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbXLUOLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbXLUOLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:11:07 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:53223 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbXLUOLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:11:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Km2A5s8OR6xyQ5XGXsP83+rC9/TzfqxILISMLH+jHM6psPYQ5MOE1ZFGn+tJFHhynZ1FQaxJ87ZuEqquUR6PFVDKX8Lknf3s0y+lLk0jAvxe0XVhvLoWEYRM4S6tTlM76jjXQUbnxMOA6QsONootSsAcjEtkaq1gKRyMo0kD7HE=
Message-ID: <8b67d60712210611j6169e262vd761b1d1aca75eb4@mail.gmail.com>
Date: Fri, 21 Dec 2007 14:11:02 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [PATCH - SH/Dreamcast] Add support for GD-Rom device
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       "Paul Mundt" <lethal@linux-sh.org>
In-Reply-To: <20071221121441.GB11583@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60712201559h5dbb2a17q8f16223b26b88006@mail.gmail.com>
	 <8b67d60712201607k66d67fa2la8b21fc698fdb3ab@mail.gmail.com>
	 <20071221121441.GB11583@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/12/2007, Jens Axboe <jens.axboe@oracle.com> wrote:
>
> Your design is also heavily geared towards there just being a single
> CDROM, I'm assuming this wont be a problem given your hw (it sets a bad
> example for others to follow though, lots of violations against normal
> programming practice for multiple devices and smp).


Yes, because is there only one device and there will only ever be one
device (unless you know of somebody doing Dreamcast hardware
development).

I understand the point you are making but adding in additional code
would only diminish resource availability or slow performance on a
small machine without actually delivering any better outcomes for
kernel users..

Is it reaslly necessary?
