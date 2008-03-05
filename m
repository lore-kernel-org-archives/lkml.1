Return-Path: <linux-kernel-owner+w=401wt.eu-S1760398AbYCEQq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398AbYCEQq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbYCEQqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:46:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:56336 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYCEQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:46:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cMX8XFVsYVSKWcmS0Qa6ZDs5J+Sc4fILHOGolz+da0ynIVgAonLIy/3ewcyyAQdgF1HYadI6emRoW/typFbfJLk0KnCjfXrkLHxDMvU0sKbRYTCp+qFoZCxTDvpGx6o26Avg2mr9K26ln3VLArGVPbm+uXr7iM7f6px9EK7gSZw=
Message-ID: <58cb370e0803050846t7dbd65d6ocfec7ca5e93aa6db@mail.gmail.com>
Date: Wed, 5 Mar 2008 17:46:08 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: [patch 3/3] pata: "I do not think it means, what you think it means."
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, alan@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <m3ir015du5.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803042316.m24NGI7k002489@imap1.linux-foundation.org>
	 <20080304173058.7679b7c8.akpm@linux-foundation.org>
	 <20080305115610.397b3ea3@the-village.bc.nu>
	 <200803051421.14167.bzolnier@gmail.com>
	 <m3ir015du5.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 5:34 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> writes:
>
>  > IBM-DTLA-307030 is on the blacklist....
>
>  Any still in use? Surpised.

https://bugzilla.redhat.com/show_bug.cgi?id=433557

the bug was opened two weeks ago so I assume that the drive is still in use

[ Actually, I'm not surprised as we are getting patches/reports for much
  older/buggier hardware...  After all we are doing Linux not some other
  OS whose every release obsoletes the old hardware. ;-) ]
