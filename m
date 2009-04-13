Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZDMBES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZDMBES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 21:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZDMBEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 21:04:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:8340 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbZDMBD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 21:03:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nWeFxS/ZpV/mN6a2RKmql9S93N6KA/fSJK0HODQ+8UwzsGGUhKyDGgiRIZgor7LLYa
         pV93TNOFH+DyJPvaGhyM2uyjU3Jxe2by6fdfEnMHtIvbQngUp6gOMeeQV5pBtWXnCpMk
         YRLBZ3/hSkVknpCETcCCsVDR6J09xJ8f8pVNc=
Date: Sun, 12 Apr 2009 18:03:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.30-rc1
Message-ID: <20090413010345.GA11041@dtor-d630.eng.vmware.com>
References: <20090408072935.GA27920@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408072935.GA27920@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 12:29:35AM -0700, Dmitry Torokhov wrote:
> Hi Linus,
> 
> Please pull from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> or
> 	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
> 
> to receive updates for the input subsystem. Bunch of new drivers plus
> some cleanups to existing ones, nothing too exciting. It looks like I
> managed to miss the merge window. Oh well...
> 

*ping* Any chance this could still be pulled? There were no significant
changes to the core code, just simple bugfixes and a few new drivers,
and the changes has been in the linux-next forever...

-- 
Dmitry
