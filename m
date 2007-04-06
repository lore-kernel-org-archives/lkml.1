Return-Path: <linux-kernel-owner+w=401wt.eu-S1767632AbXDFNbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767632AbXDFNbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767646AbXDFNbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:31:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:7276 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767632AbXDFNbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:31:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=NatgpauhHIY8aHUAHBZ/p1oPmDvwO9UoXjlkKWin2ziiS0vRwDdPPFRwkDcypcJvuvkoyihM6QxiSXBhPV3B/3JoQzvFe3ar8tWSH4B/QGhfhJJoiTKgPAQYj0WrRsdPvVj+vfV4iZG7SedvDEXg1LXbQrd3TEEFp8me7WlOc2s=
Date: Fri, 6 Apr 2007 21:34:37 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Michael <gonwg@hotmail.com>
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: set up new kernel with grub
Message-ID: <20070406133437.GA3784@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Michael <gonwg@hotmail.com>,
	"linux-os (Dick Johnson)" <linux-os@analogic.com>,
	linux-kernel@vger.kernel.org
References: <BAY113-DAV124C8565330DC6C51B2B09B9660@phx.gbl> <Pine.LNX.4.61.0704041246010.5035@chaos.analogic.com> <BAY113-DAV11F86E1B1E91A799AB05E9B9650@phx.gbl> <20070406031513.GB2407@localhost.localdomain> <BAY113-DAV1002875F3A5E59C668B830B9640@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY113-DAV1002875F3A5E59C668B830B9640@phx.gbl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 09:23:38AM -0500, Michael wrote:
>Hi, Wang,
>
>Thanks for replying. So which step is doing the compilation of each 
>module , "make oldconfig" or "make" ? For compilation, I mean the step 
>to compile the source code to .o file.
>
>Regards,
>
>Mike
>

'Make' does that. 'Make oldconfig' just checks and ajusts the .config file.

