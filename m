Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZGNQ0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZGNQ0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbZGNQ0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:26:37 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:38188 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbZGNQ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:26:35 -0400
Date: Tue, 14 Jul 2009 09:25:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] MAINTAINERS: Coalesce name and email address lines
Message-Id: <20090714092533.533e9cf2.randy.dunlap@oracle.com>
In-Reply-To: <1247522300.4008.37.camel@Joe-Laptop.home>
References: <cover.1247517373.git.joe@perches.com>
	<1247522300.4008.37.camel@Joe-Laptop.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4A5CB16B.0162:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 14:58:19 -0700 Joe Perches wrote:

> On Mon, 2009-07-13 at 14:14 -0700, Joe Perches wrote:
> > A collection of cleanup patches to MAINTAINERS
> 
> I ran the script I submitted awhile back on MAINTAINERS
> after these [0/16] patches are applied.
> 
> http://lkml.org/lkml/2009/6/1/275
> 
> I think the result is useful for people that rely
> on copy and paste of email addresses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, Joe.

>  MAINTAINERS | 2722 ++++++++++++++++++++---------------------------------------
>  1 files changed, 908 insertions(+), 1814 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5befb1c..f64b085 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -73,8 +73,8 @@ Note: For the hard of thinking, this list is meant to remain in alphabetical
>  order. If you could add yourselves to it in alphabetical order that would be
>  so much easier [Ed]
>  
> -P: Person
> -M: Mail patches to
> +P: Person (obsolete)
> +M: Mail patches to: FullName <address@domain>
>  L: Mailing list that is relevant to this area
>  W: Web-page with status/info
>  T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
