Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbZD2Nrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbZD2Nrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758001AbZD2NrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:47:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:29401 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757769AbZD2NrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=krs9GMX1PXAgQcbn1u9+w47np5CDctsjmp6FI7y72rujoBuLWoZVpHEysrYlDAyB7A
         2AxR9rjvMKr//5hjICJLNAdnqiwksW3BpROnsdVjl3jBjM+/cK5hRN2wza+BylFbLrqu
         jwYyc1bjmL7NIMuikv3NOe9MxzNJzfkHgGZQY=
Date: Wed, 29 Apr 2009 09:46:39 -0400
From: Josh Boyer <jwboyer@gmail.com>
To: Deepak Gaur <dgaur@cdotd.ernet.in>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Powerpc Port linux-2.6.29
Message-ID: <20090429134639.GB2431@yoda.jdub.homelinux.org>
References: <20090429110648.M98089@cdotd.ernet.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429110648.M98089@cdotd.ernet.in>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 04:44:33PM +0530, Deepak Gaur wrote:
>Hi all
>
>I have a custom board with MPC8560 and 1GB DDR SDRAM. I am trying to port linux - 2.6.29
>on this board. The U-BOOT is already ported on the board and is working.
>
>The OS uImage is stored in code flash at address 0xe0000000 and OS is booted by U-BOOT 
>While OS do boot but after some prints weired errors start showing up. Rootfile system
>is NFS based . I have checked the register values with Hardware person using Trace32
>emulator and they are as expected.

You might have better luck emailing the linuxppc-dev mailing list.

josh
