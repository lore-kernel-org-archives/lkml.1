Return-Path: <linux-kernel-owner+w=401wt.eu-S1161226AbXBOUxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161226AbXBOUxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161228AbXBOUxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:53:20 -0500
Received: from gw.goop.org ([64.81.55.164]:58554 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161226AbXBOUxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:53:19 -0500
Message-ID: <45D4C83E.3030304@goop.org>
Date: Thu, 15 Feb 2007 12:53:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, "Bryan O'Sullivan" <bos@serpentine.com>
Subject: Re: linux-kernel mercurial repository tags are gone!
References: <45D4AB24.9050306@redhat.com>
In-Reply-To: <45D4AB24.9050306@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Only "tip" and "v2.6.20-rc7" have tags now:
>
> 	http://www2.kernel.org/hg/linux-2.6/tags
>
> Apparently convert-repo blew the rest away on Jan 31:
>
> 	http://www2.kernel.org/hg/linux-2.6/rev/f99a8b402753
>   

It was fixed for a while, and then it broke again.  Bryan said that the
tip manifest seems to be pointing to the wrong version of .hgtags.

    J
