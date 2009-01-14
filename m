Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbZANU6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbZANU6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZANU6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:58:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:61778 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbZANU6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:58:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iuD0WWvoijVhSsnmKLx7+Mm1CZIHVq8WjFBvQ8o/8rmOk/Yv4DytqLGsxkDT4PZ/p4
         mD5TOAJuqD0CoZ18hGlAXszwtcSoAbWp+5ZBiic6cNQsa8y+7GnvmcqfqM+qtzR8Ayhz
         8GqsHcXkH0FegvuPa4PhKCAPnOTw5YnzQ5+iY=
Date: Wed, 14 Jan 2009 23:58:40 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       harvey.harrison@gmail.com, jaswinderrajput@gmail.com
Subject: Re: [patch 0/5] x86 -tip: headers cleanup
Message-ID: <20090114205840.GD8178@localhost>
References: <496e4e23.0305560a.4545.ffffaf3c@mx.google.com> <20090114205504.GB4076@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114205504.GB4076@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Wed, Jan 14, 2009 at 09:55:04PM +0100]
| On Wed, Jan 14, 2009 at 11:37:45PM +0300, Cyrill Gorcunov wrote:
| > Small series of headers cleanup, easy to bisect.
| > make headers_check still complains about vars
| > being found in comments but this is just a false
| > alarm. Please review.
| 
| Looked good when I ran through them.
| As for the sys_arch_prctl() I do not know.
| 
| Feel free to add my Acked-By.
| 
| 	Sam
| 

Thanks Sam!

		- Cyrill -
