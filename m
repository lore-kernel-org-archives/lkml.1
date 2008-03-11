Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbYCKErW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbYCKErW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYCKErP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:47:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:17221 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYCKErN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:47:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rrSRNKN3gHJH9LrbyIqMgC2lE1aPaf4+dmyuGmgWmY+TRtlCltNtuUuF6C3Nhm5AWLpnHpPQHJGxVipE5KWMuOSb03GIgP+IfOapJB+aIJoSzwa6zveUbkoFeKGaba6491nnFl6S6XnssnuWDHmVoklCy2Rk2DQD6kVQktDyHN4=
Date: Tue, 11 Mar 2008 07:46:08 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jerry Geis <geisj@pagestation.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: centos 5.1 and 2.6.24.3
Message-ID: <20080311044608.GA4589@martell.zuzino.mipt.ru>
References: <47D5B366.8040605@pagestation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D5B366.8040605@pagestation.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 06:17:10PM -0400, Jerry Geis wrote:
> I am using centos 5.1 along with 2.6.24.3 (as I want to use kvm-amd).
> All this is working. I think by default this uses the new completely fair 
> scheduler.
>
> I want to default back to the old scheduler but compile with 
> virtualization.
> What option is it in the make menuconfig that is for the old scheduler.

There is no such option.

