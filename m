Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZIQEyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZIQEyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 00:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZIQEyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 00:54:53 -0400
Received: from claw.goop.org ([74.207.240.146]:34939 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbZIQEyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 00:54:53 -0400
Message-ID: <4AB1C120.1040205@goop.org>
Date: Wed, 16 Sep 2009 21:54:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Miroslav Rezanina <mrezanin@redhat.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH][v2.6.29][XEN] Return unused memory to
 hypervisor
References: <1534444399.205511253162638763.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1534444399.205511253162638763.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/09 21:43, Miroslav Rezanina wrote:
> Ups.....This should not be commented out. I will resent the patch with
> correct (uncommented) line.

I've already applied a variant of your patch.  Check the
rebase/core-freemem branch in xen.git.

    J

