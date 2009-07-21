Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbZGUPqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbZGUPqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZGUPp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:45:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:22295 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbZGUPp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ppE2NQu+O0O+DG8FBWBG9eC92atKNVpx+MXIETSEOeWFsY23b1rwQwlZ5g29vMGbxq
         o/0N8UR9iA9Jp1fL6Ab8jz0uN66oIwQoqcIUFaiTsVEbhPr6GkHsEjPd5Xm5D1xZJKvV
         2pccYPMptWlihwYi9bz++BSc5vIlgJ89o4Y5s=
Date: Tue, 21 Jul 2009 08:45:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Driver core: make pm operations a const pointer
Message-ID: <20090721154550.GA4352@dtor-d630.eng.vmware.com>
References: <20090721055136.GB4671@dtor-d630.eng.vmware.com> <200907211546.49906.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907211546.49906.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 03:46:49PM +0200, Rafael J. Wysocki wrote:
> Hi Dmitry,
> 
> Please always Cc linux-pm on PM-related patches.
> 

My apologies, will do next time.

-- 
Dmitry
