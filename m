Return-Path: <linux-kernel-owner+w=401wt.eu-S965585AbXBOIwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585AbXBOIwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 03:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965586AbXBOIw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 03:52:29 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:60024 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965585AbXBOIw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 03:52:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dBx8jMk3VgaI3ocp/gL0jbnrPEGFkyJnwX/NiquFcdypT3Y04ppUDeIj/cUYYrNp7vXkR/od68FXm7P5OtYYO0urvqaS2S0Q34DRBFdsgza+eTFI2fihMa97NC8AfRGNrnRIVrWO8CyeREW8cqM4DYXYEjqnuhzUG9xtP5qSa2c=
Message-ID: <8d158e1f0702150052l25fb03fnf17ba315dc6f912d@mail.gmail.com>
Date: Thu, 15 Feb 2007 09:52:27 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [LIBATA] drives not detected
In-Reply-To: <8d158e1f0702150048x4eb73acawc3c3b87d0d80a6d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702150048x4eb73acawc3c3b87d0d80a6d4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> Good morning all,

> Now, when I boot up, I miss two drives, exactly the two connected to
> this promise card.
> I have another onboard Promise controller which works just fine, so
> the driver gets loaded properly, and since i see all my other disks
> but these two I think we can rule out a misconfiguration of the kernel
> config this time ;-)

It would be nice if I'd also mention the kernel I use eh.
It's linux-2.6-git8


Patrick
