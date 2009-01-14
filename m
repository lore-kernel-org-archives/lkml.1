Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbZANUxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbZANUxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbZANUxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:53:22 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:33215 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbZANUxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:53:22 -0500
Date: Wed, 14 Jan 2009 21:55:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       harvey.harrison@gmail.com, jaswinderrajput@gmail.com
Subject: Re: [patch 0/5] x86 -tip: headers cleanup
Message-ID: <20090114205504.GB4076@uranus.ravnborg.org>
References: <496e4e23.0305560a.4545.ffffaf3c@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496e4e23.0305560a.4545.ffffaf3c@mx.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 11:37:45PM +0300, Cyrill Gorcunov wrote:
> Small series of headers cleanup, easy to bisect.
> make headers_check still complains about vars
> being found in comments but this is just a false
> alarm. Please review.

Looked good when I ran through them.
As for the sys_arch_prctl() I do not know.

Feel free to add my Acked-By.

	Sam
