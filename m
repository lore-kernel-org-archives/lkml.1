Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbXEOUcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbXEOUcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 16:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbXEOUcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 16:32:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:61077 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbXEOUcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 16:32:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WWYFPHgY2FiSrOfEtv1b6Emog5GFMT9TQY/bRI6j0t8sZgPf9ZYPYsW6U1Wpiz5OCMBqvnOivO8H5nOWYMPEW1eeMEeMwIhruUC1OBZUF2envP1mRltYxlogQYXhtc9oYPll102h/VUh8VJxCuV6waffMMl9zj18s4jaOUnLFwU=
Message-ID: <9929d2390705151332x53d483e5tec1b4290c56786c7@mail.gmail.com>
Date: Tue, 15 May 2007 13:32:09 -0700
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Peter Oruba" <peter.oruba@amd.com>
Subject: Re: [PATCH 2/2] PCI-X/PCI-Express read control interfaces
Cc: gregkh@suse.de, cramerj@intel.com, john.ronciak@intel.com,
       jesse.brandeburg@intel.com, auke-jan.h.kok@intel.com, rolandd@cisco.com,
       halr@voltaire.com, linux-driver@qlogic.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
In-Reply-To: <200705151403.07646.peter.oruba@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705151350.28330.peter.oruba@amd.com>
	 <200705151403.07646.peter.oruba@amd.com>
X-Google-Sender-Auth: ed837a993acb9233
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/07, Peter Oruba <peter.oruba@amd.com> wrote:
> These driver changes incorporate the proposed PCI-X / PCI-Express read byte
> count interface. Reading and setting those valuse doesn't take
> place "manually", instead wrapping functions are called to allow quirks for
> some PCI bridges.
>
> Signed-off by: Peter Oruba <peter.oruba@amd.com>
> Based on work by Stephen Hemminger <shemminger@linux-foundation.org>
>

Ack.

-- 
Cheers,
Jeff Kirsher
