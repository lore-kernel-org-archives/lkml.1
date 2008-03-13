Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbYCMUPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbYCMUPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbYCMUPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:15:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:41253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbYCMUPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:15:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=uP7jZBKTqcC3cAqCMYUo10OQe890/ks11Gf/6msmoyK+dwNnXmH4ezPFK1cPFkUowI47DVQfkWlh1YrcCxqvuIlyM/CS2hANyENXMMg65cn+2qXasR5Us9KTjwlZy+RZjeMrvGXesuSNtyLxmi7M4s5kbNKS5be3gqcCm1L3W0M=
Date: Thu, 13 Mar 2008 16:15:20 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: document i8042.noloop
Message-ID: <20080313161451.ZZRA012@mailhub.coreip.homeip.net>
References: <Pine.LNX.4.64.0803131423370.30831@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803131423370.30831@jikos.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 02:25:41PM +0100, Jiri Kosina wrote:
> Document 'noloop' kernel parameter of i8042 controller driver. Pointed out 
> in #10236.
> 

Applied, thank you Jiri.

-- 
Dmitry
