Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZICX0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZICX0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 19:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932448AbZICX0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 19:26:23 -0400
Received: from claw.goop.org ([74.207.240.146]:45603 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035AbZICX0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 19:26:22 -0400
Message-ID: <4AA050A0.90609@goop.org>
Date: Thu, 03 Sep 2009 16:26:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Miroslav Rezanina <mrezanin@redhat.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
References: <1962776416.772071250687130436.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1962776416.772071250687130436.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/09 06:05, Miroslav Rezanina wrote:
> when running linux as XEN guest and use boot parameter mem= to set memory lower then is assigned to guest, not used memory should be returned to hypervisor as free. This is working with kernel available on xen.org pages, but is not working with kernel 2.6.29. Comparing both kernels I found code for returning unused memory to hypervisor is missing. Following patch add this functionality to 2.6.29 kernel.
>   

Are you planning on submitting a revised patch along the lines I suggested?

Thanks,
    J
