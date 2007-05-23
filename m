Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbXEWSU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbXEWSU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbXEWSUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:20:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:55155 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbXEWSUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=imr5EU+OQYWTOyeffW2EXCS8lHDBmsl5Emw84PmEPbSlqbjn0IbHVIjTubW4a39uDHBV2iFXywjYz1n8NTxoU2JKMvvUuFxrTt+F0GuYQLMs6ZnVUjIPCmMvd9TWVi1MZTLCez5hSqrdo+echqDJyi896tbVnh7piGXQUZc/V/M=
Message-ID: <d9b9d95f0705231120p1b3a2a8ey59ca01c7552f43f8@mail.gmail.com>
Date: Wed, 23 May 2007 19:20:45 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] joydev.c automatic re-calibration
Cc: linux-kernel@vger.kernel.org, "Dmitry Torokhov" <dtor@mail.ru>
In-Reply-To: <20070523110013.5ffc4a91.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705221733l46de4262qd9c3f5047c53667@mail.gmail.com>
	 <20070523110013.5ffc4a91.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> A few patch protocol things:
>
> - Please always prepare patches in `patch -p1' form
>
> - Include a Signed-off-by: as per Documentation/SubmittingPatches,
>   section 11.
>
> - Avoid including two copies of the patch in the one email.  Inlined plain
>   text is preferred, ext/plain attachments are grudgingly accepted.
>
> I descrambled the patch, fixed a reject and queued it up in the -mm tree
> for Dmitry's consideration, thanks.

Hi Andrew,

sorry for the confusion, I'm following up with Dimitri and Jiri and
hopefully will have a patch following the protocol next time. ;)

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
