Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbXF3DKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbXF3DKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXF3DKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:10:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:57661 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbXF3DKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NHsde3Q8gmqtCoR+b4fp3FQ64EXfwu0PI1V4SGAaBDmsKqVBB6mmOnLlavnFdBojhAqSJavObPV9wXNcjGBbMjOXB8qFCOeV9ds0o6ETi4g8j6xZtpnChx3oKA+3cFS7CVNsesnV37Y84OtTN6a9F+Oe8GNGbal8vJtX3w0Uedk=
Message-ID: <a781481a0706292010w4d28305eu4b9280333afd4e6b@mail.gmail.com>
Date: Sat, 30 Jun 2007 08:40:00 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [RFC] automatic CC generation for patch submission
Cc: "Dan Aloni" <da-x@monatomic.org>,
       "Linux Kernel List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4685C549.3020602@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070630023451.GA21593@localdomain> <4685C549.3020602@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/07, Kok, Auke <auke-jan.h.kok@intel.com> wrote:
> [...]
> an easier way to implement this is to add an extra field in the MAINTAINERS
> file, something like below. All the contact info would stay the same, closely
> where applicable and it would allow you to also specify specific files as well.

Hmm, associating MAINTAINERS and source files. I remember surfing LKML
archives one day and coming across this huge and ugly flamefest when some
guy called Eric S. Raymond (hehe :-) suggested something like this and got
burned.

Cheers,
S
