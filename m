Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZCKREY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZCKREY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZCKREO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:04:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:10476 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZCKREN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:04:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=T/M5zgWMsbO7wcZNTRCk2+aJlUOSJr2u06KlOJZkI3jtl+ZWKcleJ1QzwZdgbxVyEF
         oFUL1gT0YRYMDYmfJLeHNkadR1ZANYh3vCWIbgZLJV1iztow9gAdhCBBKhgxPUZYyVQR
         AOMj+bn1XR+V1NqpK7ik14iElU1HuN3c6642k=
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
From: Alessandro Bono <alessandro.bono@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
       linux-xfs <linux-xfs@oss.sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090302133609.GD23880@duck.suse.cz>
References: <1234011974.7435.11.camel@champagne.cantina>
	 <20090208222859.GA2532@infradead.org>
	 <1234132752.12370.0.camel@champagne.cantina>
	 <20090208224249.GA11931@infradead.org>
	 <1234133120.12370.7.camel@champagne.cantina>
	 <20090209075308.GA7360@infradead.org> <20090210104304.GP8830@disturbed>
	 <1234432077.9204.15.camel@champagne.cantina>
	 <20090226165838.GA9602@atrey.karlin.mff.cuni.cz>
	 <1235763895.5743.3.camel@champagne>  <20090302133609.GD23880@duck.suse.cz>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 18:04:06 +0100
Message-Id: <1236791046.5814.12.camel@champagne>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 14:36 +0100, Jan Kara wrote:
.....

>   Such bit flips are usually caused by faulty memory or other HW (io
> controler etc.) so I suggest trying to shuffle the hardware somehow -
> change memory DIMMs as a starter, running memtest if you don't have a spare
> DIMMs but it is not an exception that even though memtest runs just fine
> for a long time, memory is really at fault.

Hi

I changed DIMMs on my laptop and after that I can't reproduce bug
So at the end it's an hardware problem

Many thanks to you, Dave and Christoph for your time and patience 

-- 
Cordiali Saluti
Alessandro Bono

