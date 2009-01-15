Return-Path: <linux-kernel-owner+w=401wt.eu-S934397AbZAOXDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934397AbZAOXDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935593AbZAOWyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:54:46 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:65125 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935020AbZAOWyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:54:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:organization:message-id:references
         :in-reply-to:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=CqYXh/Hd2T9l3OE5jiqSlv+rsVLa8jSVB5mqEYT1U96KPhA2w0DmxWO/k2KnzPib8W
         lEQ03Anpk1ccFNvRu3OV00Q9GfsWlYufDVd7SO3JHD/qWWLau1IpsFcuwvzQz45vPm6D
         DnvP85H71b4NMXAe+m3ywJrsLELE7fvRwwZZg=
From: Grant Coady <gcoady.lk@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/85] 2.6.27.12-stable review
Date: Fri, 16 Jan 2009 09:54:31 +1100
Organization: scattered
Message-ID: <vifvm49imd48dmmsbg34d44on2hevn6a6q@4ax.com>
References: <20090115215812.GA17227@kroah.com>
In-Reply-To: <20090115215812.GA17227@kroah.com>
X-Mailer: Forte Agent 5.00/32.1171
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 13:58:12 -0800, you wrote:

>This is the start of the stable review cycle for the 2.6.27.12 release.
>There are 85 patches in this series, all will be posted as a response to
>this one.  If anyone has any issues with these being applied, please let
>us know.  If anyone is a maintainer of the proper subsystem, and wants
>to add a Signed-off-by: line to the patch, please respond with it.
>
>These patches are sent out with a number of different people on the Cc:
>line.  If you wish to be a reviewer, please email stable@kernel.org to
>add your name to the list.  If you want to be off the reviewer list,
>also email us.
>
>Responses should be made by Saturday, January 17, 20:00:00 UTC.
>Anything received after that time might be too late.
>
>The whole patch series can be found in one patch at:
>	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.12-rc1.gz
>and the diffstat can be found below.

Hey Greg, you hid the file?

$ wget http://kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.12-rc1.gz
--09:52:29--  http://kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.12-rc1.gz
           => `patch-2.6.27.12-rc1.gz'
Resolving kernel.org... 149.20.20.133, 204.152.191.37
Connecting to kernel.org|149.20.20.133|:80... connected.
HTTP request sent, awaiting response... 404 Not Found
09:52:29 ERROR 404: Not Found.

Grant.
-- 
http://bugsplatter.id.au
