Return-Path: <linux-kernel-owner+w=401wt.eu-S1761166AbYHOTE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761166AbYHOTE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758352AbYHOTEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:04:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:40065 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085AbYHOTEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:04:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TGBKLBsF1b/kLYZJcCnCv/hC2rqGXg2y1+mYR7VbxVS6MwLa8dpBvqPKkzWYXTN+62
         HWden53nr17opitRJND6EJ+M2w4u1CskRguPLzLm0TPBTwGJlwCXMOxSudkopAwOtNdA
         KuM1hrHyJhyhG7WIxvnhApt7BV90SRgt1XL50=
Date: Fri, 15 Aug 2008 15:04:44 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make Dell keyboard repeat quirk apply to a wider range
	of hardware
Message-ID: <20080815150420.ZZRA012@mailhub.coreip.homeip.net>
References: <20080814033255.GA21721@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814033255.GA21721@srcf.ucam.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 04:32:55AM +0100, Matthew Garrett wrote:
> Dell laptops fail to send key up events for several of their special 
> keys. There's an existing quirk in the kernel to handle this, but it's 
> limited to the Latitude range. This patch extends it to cover all 
> portable Dells.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 

Applied to 'next', thank you Matthew.

-- 
Dmitry
